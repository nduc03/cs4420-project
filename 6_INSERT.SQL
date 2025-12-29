-- ==========================================================
-- DATA INSERTION SCRIPT (FULL DEMO VERSION - ENGLISH COMMENTS)
-- ==========================================================

USE test;

-- 1. CLEAN UP (Clean start to avoid FK errors)
-- ----------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE payment;
TRUNCATE TABLE feedback;
TRUNCATE TABLE invoice;
TRUNCATE TABLE contribution;
TRUNCATE TABLE collaboration_event;
TRUNCATE TABLE affiliate;
TRUNCATE TABLE agreement;
TRUNCATE TABLE primary_contact;
TRUNCATE TABLE contact_point;
TRUNCATE TABLE partner;
TRUNCATE TABLE organization_unit;
SET FOREIGN_KEY_CHECKS = 1; -- Bật lại

-- 2. Insert ORGANIZATION UNITS (HUST Data)
-- ----------------------------------------------------------
INSERT INTO organization_unit (id, unit_scope, name, established_date) VALUES
(1, 'school/university', 'Hanoi University of Science and Technology (HUST)', '1956-03-06'),
(2, 'faculty', 'School of Information and Communication Technology (SoICT)', '2022-12-01'),
(3, 'faculty', 'School of Electrical and Electronics Engineering (SEEE)', '2022-12-01'),
(4, 'faculty', 'School of Applied Mathematics and Informatics (SAMI)', '2023-12-01'),
(5, 'lab/center', 'International Research Center for AI (BK.AI)', '2018-01-01'),
(6, 'lab/center', 'Center for Business Cooperation', '2010-06-20');

-- 3. Insert PARTNERS (10 Partners)
-- ----------------------------------------------------------
INSERT INTO partner (id, type, name, status, website, tax_code, industry, notes) VALUES
(1, 'organization', 'FPT Software', 'active', 'https://fpt-software.com', '0101234567', 'IT & Software', 'Strategic partner'),
(2, 'organization', 'Viettel Group', 'active', 'https://viettel.com.vn', '0109876543', 'Telecommunications', 'Scholarship provider'),
(3, 'organization', 'Samsung R&D', 'active', 'https://research.samsung.com', '0203040506', 'Electronics', 'Internship host'),
(4, 'organization', 'Vingroup Big Data', 'prospect', 'https://vinbigdata.org', '0304050607', 'AI & Data Science', NULL),
(5, 'organization', 'TopCV Vietnam', 'active', 'https://topcv.vn', '0405060708', 'Recruitment', 'Career fair sponsor'),
(6, 'organization', 'Sun Asterisk', 'inactive', 'https://sun-asterisk.com', '0506070809', 'Software Outsourcing', NULL),
(7, 'organization', 'MISA JSC', 'active', 'https://misa.vn', '0607080910', 'Accounting Software', NULL),
(8, 'person', 'Prof. Nguyen Van A', 'active', 'https://scholar.google.com/nva', NULL, 'Education', 'Alumni, Guest Lecturer'),
(9, 'person', 'Dr. Peter Smith', 'prospect', NULL, NULL, 'AI Researcher', 'Visiting Professor from US'),
(10, 'person', 'Ms. Tran Thi B', 'active', NULL, NULL, 'HR Consultant', 'Soft skill trainer');

-- 4. Insert CONTACT POINTS (Demo 1 Partner - Multiple Contacts)
-- ----------------------------------------------------------
INSERT INTO contact_point (id, partner_id, name, email, phone, title) VALUES
-- Primary Contacts (To be linked in primary_contact table)
(1, 1, 'Nguyen Tuan Minh', 'minhnt@fpt.com', '0901111222', 'HR Director'),      -- FPT Contact 1 (Primary)
(2, 2, 'Le Thi Lan', 'lanlt@viettel.com.vn', '0902222333', 'Technical Lead'), -- Viettel Contact 1 (Primary)
(3, 3, 'Park Ji Sung', 'p.jisung@samsung.com', '0903333444', 'R&D Manager'),  -- Samsung Contact 1 (Primary)
(4, 8, 'Nguyen Van A', 'nva.prof@gmail.com', '0908888999', 'Professor'),      -- Prof. A (Primary)

-- Secondary Contacts (NOT primary -> Demo 1-N relationship)
(5, 1, 'Pham Van Talent', 'talent@fpt.com', '0905555666', 'Recruitment Lead'), -- FPT Contact 2 (Secondary)
(6, 2, 'Nguyen Van Sales', 'sales@viettel.com', '0907777888', 'Account Manager'); -- Viettel Contact 2 (Secondary)

-- Link Primary Contacts
INSERT INTO primary_contact (partner_id, contact_id) VALUES
(1, 1), -- FPT selects Minh as Primary (Contact ID 5 is skipped here -> correct logic)
(2, 2), -- Viettel selects Lan as Primary (Contact ID 6 is skipped)
(3, 3),
(8, 4);

-- 5. Insert AFFILIATES (Demo M-N Relationship)
-- ----------------------------------------------------------
-- This table indicates which Partner is affiliated with which University Unit
INSERT INTO affiliate (organization_unit_id, partner_id, affiliated_since) VALUES
(2, 1, '2015-01-01'), -- SoICT (ID 2) affiliated with FPT (ID 1)
(2, 3, '2018-05-20'), -- SoICT (ID 2) affiliated with Samsung (ID 3)
(3, 2, '2016-03-15'), -- SEEE (ID 3) affiliated with Viettel (ID 2)
(5, 4, '2020-01-10'), -- AI Lab (ID 5) affiliated with VinBigData (ID 4)
(5, 3, '2019-08-01'), -- AI Lab (ID 5) also affiliated with Samsung (ID 3) -> Samsung is affiliated with 2 units
(4, 8, '1990-09-05'); -- SAMI (ID 4) affiliated with Prof. A (ID 8 - Alumni)

-- 6. Insert COLLABORATION EVENTS
-- ----------------------------------------------------------
INSERT INTO collaboration_event (id, title, type, location, start_time, end_time, number_of_students, partner_id) VALUES
(1, 'FPT Career Tour 2024', 'guest lectures', 'Hall C2', '2024-03-10 09:00:00', '2024-03-10 12:00:00', 200, 1),
(2, 'Viettel Future Gen Scholarship', 'seminars', 'Ta Quang Buu Hall', '2024-04-15 14:00:00', '2024-04-15 16:00:00', 150, 2),
(3, 'Samsung Algorithms Workshop', 'workshops', 'Lab D9', '2024-05-20 08:00:00', '2024-05-20 17:00:00', 50, 3),
(4, 'AI Hackathon with VinBigData', 'hackathons', 'Library Hall', '2024-06-01 08:00:00', '2024-06-02 20:00:00', 100, 4),
(5, 'CV Writing Masterclass', 'workshops', 'Online Zoom', '2024-07-10 19:00:00', '2024-07-10 21:00:00', 300, 5),
(6, 'Guest Lecture: Blockchain 101', 'guest lectures', 'Room D9-401', '2024-08-05 09:00:00', '2024-08-05 11:00:00', 80, 8),
(7, 'Joint Research: NLP for Vietnamese', 'joint research activities', 'AI Lab B1', '2024-01-01 00:00:00', '2024-12-31 00:00:00', 5, 8),
(8, 'Soft Skills for Engineers', 'seminars', 'Hall C2', '2024-09-15 08:30:00', '2024-09-15 11:30:00', 120, 10),
(9, 'MISA Code War', 'competitions', 'Online', '2024-10-10 08:00:00', '2024-10-10 17:00:00', 500, 7),
(10, 'Industry Talk: 5G Technology', 'guest lectures', 'Hall C2', '2024-11-20 14:00:00', '2024-11-20 16:00:00', 180, 2);

-- 7. Insert CONTRIBUTIONS
-- ----------------------------------------------------------
INSERT INTO contribution (id, type, description, estimated_monetary_value, contribution_date, partner_id, event_id) VALUES
(1, 'cash', 'Sponsorship for Career Tour', 20000000.00, '2024-03-01', 1, 1),
(2, 'in-kind', '10 Scholarships vouchers', 50000000.00, '2024-04-10', 2, 2),
(3, 'in-kind', 'Training materials and lunch', 10000000.00, '2024-05-18', 3, 3),
(4, 'cash', 'Hackathon First Prize', 30000000.00, '2024-05-25', 4, 4),
(5, 'in-kind', 'Premium CV Accounts for students', 15000000.00, '2024-07-01', 5, 5),
(6, 'in-kind', 'Speaker time', 5000000.00, '2024-08-05', 8, 6),
(7, 'cash', 'Research Grant Phase 1', 100000000.00, '2024-01-15', 8, 7),
(8, 'cash', 'Hall rental support', 5000000.00, '2024-09-10', 10, 8),
(9, 'cash', 'Competition Platform Fee', 25000000.00, '2024-10-01', 7, 9),
(10, 'in-kind', 'Demo 5G Equipments', 80000000.00, '2024-11-15', 2, 10);

-- 8. Insert INVOICES
-- ----------------------------------------------------------
INSERT INTO invoice (reference_number, issue_date, amount, status, event_id, partner_id) VALUES
(1, '2024-03-05', 5000000.00, 'paid', 1, 1),
(2, '2024-04-20', 2000000.00, 'paid', 2, 2),
(3, '2024-05-25', 10000000.00, 'paid', 3, 3),
(4, '2024-06-05', 15000000.00, 'paid', 4, 4),
(5, '2024-07-15', 3000000.00, 'paid', 5, 5),
(6, '2024-08-10', 1000000.00, 'cancelled', 6, 8),
(7, '2024-02-01', 5000000.00, 'paid', 7, 8),
(8, '2024-09-20', 2000000.00, 'unpaid', 8, 10),
(9, '2024-10-15', 8000000.00, 'paid', 9, 7),
(10, '2024-11-25', 5000000.00, 'paid', 10, 2);

-- 9. Insert PAYMENTS
-- ----------------------------------------------------------
INSERT INTO payment (payment_reference, payment_date, payment_method, amount, invoice_reference_number) VALUES
(1, '2024-03-06', 'bank transfer', 5000000.00, 1),
(2, '2024-04-21', 'bank transfer', 2000000.00, 2),
(3, '2024-05-26', 'bank transfer', 10000000.00, 3),
(4, '2024-06-06', 'bank transfer', 15000000.00, 4),
(5, '2024-07-16', 'e-wallet', 3000000.00, 5),
(6, '2024-08-11', 'cash', 1000000.00, 6),
(7, '2024-02-02', 'bank transfer', 5000000.00, 7),
(8, '2024-09-21', 'cash', 1000000.00, 8),
(9, '2024-10-16', 'bank transfer', 8000000.00, 9),
(10, '2024-11-26', 'bank transfer', 5000000.00, 10);

-- 10. Insert FEEDBACK
-- ----------------------------------------------------------
INSERT INTO feedback (event_id, rater_name, rating, comments, feedback_date) VALUES
(1, 'Student K66', 5, 'Very helpful', '2024-03-11'),
(1, 'Student K67', 4, 'A bit crowded', '2024-03-11'),
(3, 'Student K65', 5, 'Challenging but excellent algorithms', '2024-05-21'),
(3, 'Student K68', 3, 'Hard to understand', '2024-05-21'),
(4, 'Team Hust-SoICT', 5, 'Professional organization', '2024-06-03'),
(5, 'Student K69', 4, 'Learned how to write a proper CV', '2024-07-11'),
(10, 'Student K66', 5, 'Excited for 5G', '2024-11-21');