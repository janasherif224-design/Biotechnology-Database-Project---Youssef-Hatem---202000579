CREATE OR REPLACE FUNCTION manage_aliquot_usage()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    available NUMERIC(8,2);
    old_volume NUMERIC(8,2);
BEGIN
    IF TG_OP = 'INSERT' THEN
        SELECT current_volume_ml INTO available
        FROM aliquots
        WHERE aliquot_id = NEW.aliquot_id
        FOR UPDATE;

        IF available IS NULL THEN
            RAISE EXCEPTION 'Aliquot % does not exist', NEW.aliquot_id;
        END IF;

        IF NEW.volume_used_ml > available THEN
            RAISE EXCEPTION 'Insufficient aliquot volume. Available: %, requested: %',
                available, NEW.volume_used_ml;
        END IF;

        UPDATE aliquots
        SET current_volume_ml = current_volume_ml - NEW.volume_used_ml,
            status = CASE
                        WHEN current_volume_ml - NEW.volume_used_ml = 0 THEN 'USED'
                        ELSE status
                     END
        WHERE aliquot_id = NEW.aliquot_id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE aliquots
        SET current_volume_ml = current_volume_ml + OLD.volume_used_ml,
            status = CASE WHEN status = 'USED' THEN 'AVAILABLE' ELSE status END
        WHERE aliquot_id = OLD.aliquot_id;

        RETURN OLD;

    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.aliquot_id = OLD.aliquot_id THEN
            SELECT current_volume_ml INTO available
            FROM aliquots
            WHERE aliquot_id = NEW.aliquot_id
            FOR UPDATE;

            available := available + OLD.volume_used_ml;

            IF NEW.volume_used_ml > available THEN
                RAISE EXCEPTION 'Insufficient aliquot volume after update. Available: %, requested: %',
                    available, NEW.volume_used_ml;
            END IF;

            UPDATE aliquots
            SET current_volume_ml = available - NEW.volume_used_ml,
                status = CASE
                            WHEN available - NEW.volume_used_ml = 0 THEN 'USED'
                            ELSE 'AVAILABLE'
                         END
            WHERE aliquot_id = NEW.aliquot_id;
        ELSE
            SELECT current_volume_ml INTO available
            FROM aliquots WHERE aliquot_id = NEW.aliquot_id FOR UPDATE;

            IF NEW.volume_used_ml > available THEN
                RAISE EXCEPTION 'Insufficient volume in new aliquot';
            END IF;

            UPDATE aliquots
            SET current_volume_ml = current_volume_ml + OLD.volume_used_ml,
                status = CASE WHEN status = 'USED' THEN 'AVAILABLE' ELSE status END
            WHERE aliquot_id = OLD.aliquot_id;

            UPDATE aliquots
            SET current_volume_ml = current_volume_ml - NEW.volume_used_ml,
                status = CASE
                            WHEN current_volume_ml - NEW.volume_used_ml = 0 THEN 'USED'
                            ELSE status
                         END
            WHERE aliquot_id = NEW.aliquot_id;
        END IF;

        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_manage_aliquot_usage ON sample_usage;

CREATE TRIGGER trg_manage_aliquot_usage
BEFORE INSERT OR UPDATE OR DELETE ON sample_usage
FOR EACH ROW
EXECUTE FUNCTION manage_aliquot_usage();
