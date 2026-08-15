INSERT INTO donors VALUES
(1,'D001','Mariam','Hassan','1998-02-14','F','O+','01010000001','mariam.h@example.com','2025-09-01','ACTIVE'),
(2,'D002','Omar','Khaled','1997-06-21','M','A+','01010000002','omar.k@example.com','2025-09-02','ACTIVE'),
(3,'D003','Salma','Adel','1999-01-09','F','B+','01010000003','salma.a@example.com','2025-09-03','ACTIVE'),
(4,'D004','Youssef','Nabil','1996-11-30','M','O-','01010000004','youssef.n@example.com','2025-09-04','ACTIVE'),
(5,'D005','Nour','Samir','2000-03-18','F','AB+','01010000005','nour.s@example.com','2025-09-05','ACTIVE'),
(6,'D006','Karim','Fathy','1998-08-05','M','A-','01010000006','karim.f@example.com','2025-09-06','ACTIVE'),
(7,'D007','Hana','Mostafa','1999-12-12','F','O+','01010000007','hana.m@example.com','2025-09-07','ACTIVE'),
(8,'D008','Adam','Sherif','1997-04-25','M','B-','01010000008','adam.s@example.com','2025-09-08','ACTIVE'),
(9,'D009','Laila','Tarek','2000-07-07','F','A+','01010000009','laila.t@example.com','2025-09-09','ACTIVE'),
(10,'D010','Seif','Mahmoud','1998-10-19','M','AB-','01010000010','seif.m@example.com','2025-09-10','ACTIVE');

INSERT INTO researchers VALUES
(1,'R001','Mona','Farid','Molecular Biology','mona.f@biobank.edu'),
(2,'R002','Ahmed','Nasser','Genomics','ahmed.n@biobank.edu'),
(3,'R003','Nada','Ibrahim','Proteomics','nada.i@biobank.edu'),
(4,'R004','Tarek','Gamal','Immunology','tarek.g@biobank.edu'),
(5,'R005','Reem','Hany','Clinical Research','reem.h@biobank.edu'),
(6,'R006','Omar','Sayed','Bioinformatics','omar.s@biobank.edu'),
(7,'R007','Lina','Adly','Molecular Diagnostics','lina.a@biobank.edu'),
(8,'R008','Karim','Lotfy','Cancer Biology','karim.l@biobank.edu'),
(9,'R009','Salma','Wadie','Cell Biology','salma.w@biobank.edu'),
(10,'R010','Yara','Fouad','Translational Medicine','yara.f@biobank.edu');

INSERT INTO consent_records VALUES
(1,1,'2025-09-01','v2.0','ACTIVE',TRUE),(2,2,'2025-09-02','v2.0','ACTIVE',TRUE),
(3,3,'2025-09-03','v2.0','ACTIVE',TRUE),(4,4,'2025-09-04','v2.0','ACTIVE',TRUE),
(5,5,'2025-09-05','v2.0','ACTIVE',TRUE),(6,6,'2025-09-06','v2.0','ACTIVE',TRUE),
(7,7,'2025-09-07','v2.0','ACTIVE',TRUE),(8,8,'2025-09-08','v2.0','ACTIVE',TRUE),
(9,9,'2025-09-09','v2.0','ACTIVE',TRUE),(10,10,'2025-09-10','v2.0','ACTIVE',TRUE);

INSERT INTO sample_types VALUES
(1,'Whole Blood','Blood','mL','Whole blood specimen'),
(2,'Plasma','Blood','mL','Plasma separated from blood'),
(3,'Serum','Blood','mL','Serum specimen'),
(4,'PBMC','Cellular','mL','Peripheral blood mononuclear cells'),
(5,'Urine','Urine','mL','Urine specimen'),
(6,'Saliva','Saliva','mL','Saliva specimen'),
(7,'DNA','Nucleic Acid','µL','Purified genomic DNA'),
(8,'RNA','Nucleic Acid','µL','Purified RNA'),
(9,'Tissue','Tissue','mg','Biopsy tissue specimen'),
(10,'Cell Lysate','Cellular','mL','Prepared cell lysate');

INSERT INTO collection_events VALUES
(1,1,'2025-09-03','Main Collection Unit','Nadia Ali','Routine collection'),
(2,2,'2025-09-04','Main Collection Unit','Nadia Ali','Routine collection'),
(3,3,'2025-09-05','Main Collection Unit','Hossam Eid','Routine collection'),
(4,4,'2025-09-06','Main Collection Unit','Hossam Eid','Routine collection'),
(5,5,'2025-09-07','Research Clinic','Maha Salem','Routine collection'),
(6,6,'2025-09-08','Research Clinic','Maha Salem','Routine collection'),
(7,7,'2025-09-09','Research Clinic','Nadia Ali','Follow-up collection'),
(8,8,'2025-09-10','Main Collection Unit','Hossam Eid','Routine collection'),
(9,9,'2025-09-11','Main Collection Unit','Maha Salem','Routine collection'),
(10,10,'2025-09-12','Research Clinic','Nadia Ali','Follow-up collection');

INSERT INTO storage_locations VALUES
(1,'FZ01','S01','B01',-80,'AVAILABLE'),(2,'FZ01','S01','B02',-80,'AVAILABLE'),
(3,'FZ01','S02','B01',-80,'AVAILABLE'),(4,'FZ01','S02','B02',-80,'AVAILABLE'),
(5,'FZ02','S01','B01',-80,'AVAILABLE'),(6,'FZ02','S01','B02',-80,'AVAILABLE'),
(7,'FZ02','S02','B01',-20,'AVAILABLE'),(8,'FZ02','S02','B02',-20,'AVAILABLE'),
(9,'FZ03','S01','B01',-20,'AVAILABLE'),(10,'FZ03','S01','B02',-20,'AVAILABLE');

INSERT INTO samples VALUES
(1,'SMP001',1,1,1,10,7,'ACCEPTED','2025-09-03'),
(2,'SMP002',2,2,2,8,5,'ACCEPTED','2025-09-04'),
(3,'SMP003',3,3,3,8,8,'ACCEPTED','2025-09-05'),
(4,'SMP004',4,4,4,6,4,'ACCEPTED','2025-09-06'),
(5,'SMP005',5,5,5,15,15,'ACCEPTED','2025-09-07'),
(6,'SMP006',6,6,6,10,10,'REVIEW','2025-09-08'),
(7,'SMP007',7,7,7,500,500,'ACCEPTED','2025-09-09'),
(8,'SMP008',8,8,8,300,300,'ACCEPTED','2025-09-10'),
(9,'SMP009',9,9,9,100,100,'ACCEPTED','2025-09-11'),
(10,'SMP010',10,10,10,8,8,'ACCEPTED','2025-09-12');

INSERT INTO aliquots VALUES
(1,1,'A001',3,3,0,'AVAILABLE'),(2,1,'A002',3,2,1,'AVAILABLE'),
(3,2,'A003',3,3,0,'AVAILABLE'),(4,2,'A004',2,2,0,'AVAILABLE'),
(5,3,'A005',4,4,0,'AVAILABLE'),(6,4,'A006',2,2,0,'AVAILABLE'),
(7,5,'A007',5,5,0,'AVAILABLE'),(8,6,'A008',3,3,0,'AVAILABLE'),
(9,7,'A009',200,200,0,'AVAILABLE'),(10,8,'A010',100,100,0,'AVAILABLE'),
(11,9,'A011',50,50,0,'AVAILABLE'),(12,10,'A012',3,3,0,'AVAILABLE');

INSERT INTO test_types VALUES
(1,'DNA Extraction','Molecular Biology',3),(2,'PCR','Molecular Biology',2),
(3,'RNA Quality Check','Genomics',3),(4,'ELISA','Immunology',5),
(5,'Sequencing Library Prep','Genomics',7),(6,'Proteomics Screen','Proteomics',6),
(7,'Cell Viability Assay','Cell Biology',2),(8,'Metabolite Panel','Clinical Chemistry',5),
(9,'Microscopy Review','Histology',4),(10,'Variant Confirmation','Genomics',4);

INSERT INTO test_requests VALUES
(1,1,'2025-09-15','HIGH','DNA quality assessment for sequencing','PENDING'),
(2,2,'2025-09-15','NORMAL','Target PCR assay','IN_PROGRESS'),
(3,3,'2025-09-16','URGENT','RNA integrity check','PENDING'),
(4,4,'2025-09-16','NORMAL','Inflammatory marker screening','PENDING'),
(5,5,'2025-09-17','HIGH','Library preparation for sequencing','IN_PROGRESS'),
(6,6,'2025-09-17','LOW','Protein abundance screen','PENDING'),
(7,7,'2025-09-18','NORMAL','Cell viability assessment','COMPLETED'),
(8,8,'2025-09-18','HIGH','Metabolic profiling','PENDING'),
(9,9,'2025-09-19','NORMAL','Tissue microscopy review','COMPLETED'),
(10,10,'2025-09-19','URGENT','Variant confirmation','PENDING');

INSERT INTO sample_test_requests VALUES
(1,1,1,0.5,'PENDING'),(1,2,2,0.8,'PENDING'),
(2,3,3,0.5,'NOT_RUN'),(3,4,4,1.0,'PENDING'),
(4,5,5,0.5,'PENDING'),(5,6,6,1.0,'NOT_RUN'),
(6,7,7,1.0,'PASSED'),(7,8,8,10.0,'PENDING'),
(9,9,9,5.0,'PASSED'),(8,10,10,2.0,'PENDING'),
(10,1,1,0.5,'PENDING');

INSERT INTO sample_usage VALUES
(1,1,1,'2025-09-16',0.5,'DNA extraction pilot','Good yield'),
(2,2,2,'2025-09-16',0.5,'PCR assay','No issue'),
(3,3,3,'2025-09-17',0.5,'RNA QC','Good quality'),
(4,4,4,'2025-09-17',0.5,'ELISA pilot','No issue'),
(5,5,5,'2025-09-18',1.0,'Library preparation','Good quality'),
(6,6,6,'2025-09-18',0.5,'Protein screen','Good signal'),
(7,7,7,'2025-09-19',1.0,'Cell assay','Viability acceptable'),
(8,9,8,'2025-09-20',10.0,'Metabolite panel','Within expected range'),
(9,10,9,'2025-09-20',5.0,'Microscopy review','Reviewed'),
(10,11,10,'2025-09-21',10.0,'Variant confirmation','DNA sufficient');

-- At least 10 meaningful rows are present in every main entity table.
