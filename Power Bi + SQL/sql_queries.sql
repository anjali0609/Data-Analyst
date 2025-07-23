create database Hospital;
select * from appointments;
select * from billing;
select * from doctors;
select * from patients;
select * from treatments;

#KPI's
# Total No of Patients
SELECT 
    COUNT(DISTINCT patient_id) AS Total_no_of_Patiens
FROM
    patients;


#Total Appointments
SELECT 
    COUNT(appointment_id) AS Total_appointments
FROM
    appointments;

#Unique patients
SELECT 
    COUNT(DISTINCT patient_id) AS Total_unique_patients
FROM
    patients;

#Daily appointment Trends
SELECT 
    appointment_date, COUNT(*) AS total_appointments
FROM
    appointments
GROUP BY appointment_date
ORDER BY appointment_date;

#Weekly appointment Trends
SELECT 
    YEAR(appointment_date) AS years,
    WEEK(appointment_date) AS weeks,
    COUNT(*) AS weekly_appointments
FROM
    appointments
GROUP BY years , weeks
ORDER BY years , weeks;

#number of appointments per doctor
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS Full_name,
    COUNT(a.appointment_id) AS total_appointments
FROM
    appointments a
        JOIN
    doctors d ON a.doctor_id = d.doctor_id
GROUP BY Full_name
ORDER BY total_appointments DESC;

# Total revenue
SELECT 
    ROUND(SUM(amount), 2) AS Total_Revenue
FROM
    billing;

#average billing amount per patient
SELECT 
    ROUND(AVG(total_billed), 2) AS Avg_billing_per_patient
FROM
    (SELECT 
        patient_id, SUM(amount) AS total_billed
    FROM
        billing
    GROUP BY patient_id) AS patient_bills; 

#Outstanding(unpaid) bill
SELECT 
    *
FROM
    billing
WHERE
    payment_status IN ('Failed' , 'Pending');

SELECT DISTINCT
    payment_status
FROM
    billing;

#Revenue per doctor
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS Full_name,
    ROUND(SUM(b.amount), 2) AS total_Revenue
FROM
    billing b
        JOIN
    appointments a ON b.patient_id = a.patient_id
        JOIN
    doctors d ON a.doctor_id = d.doctor_id
GROUP BY Full_name
ORDER BY total_Revenue DESC;

#Gender distribution
SELECT 
    gender, COUNT(*)
FROM
    patients
GROUP BY gender;

#age group
SELECT 
    CASE
        WHEN
            TIMESTAMPDIFF(YEAR,
                date_of_birth,
                CURDATE()) BETWEEN 0 AND 17
        THEN
            '0-17 (children)'
        WHEN
            TIMESTAMPDIFF(YEAR,
                date_of_birth,
                CURDATE()) BETWEEN 18 AND 35
        THEN
            '18-35 (young Adults)'
        WHEN
            TIMESTAMPDIFF(YEAR,
                date_of_birth,
                CURDATE()) BETWEEN 36 AND 55
        THEN
            '36-55 (Adults)'
        ELSE '56+ (Seniors)'
    END AS Age_group,
    COUNT(*) AS Total_patients
FROM
    patients
GROUP BY Age_group
ORDER BY Age_group; 

#1. Which doctor has the most appointments?
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS Full_name,
    COUNT(a.appointment_id) AS total_appointments
FROM
    appointments a
        JOIN
    doctors d ON a.doctor_id = d.doctor_id
GROUP BY Full_name
ORDER BY total_appointments DESC limit 1;

#What are the top reasons for patient visits?
SELECT 
    reason_for_visit, COUNT(*) AS Visit_count
FROM
    appointments
GROUP BY reason_for_visit
ORDER BY Visit_count DESC;

#What is the avg no of paitents per day/week?
SELECT 
    ROUND(AVG(Daily_count)) AS Avg_appointment_per_day
FROM
    (SELECT 
        appointment_date, COUNT(*) AS Daily_count
    FROM
        appointments
    GROUP BY appointment_date) AS Daily_Status;
    
#Monthly Revenue Trend
SELECT 
    DATE_FORMAT(bill_date, '%y-%m') AS Months,
    ROUND(SUM(amount), 2) AS Monthly_Revenue
FROM
    billing
GROUP BY Months
ORDER BY Months;

#How many repeat patient do we have?
SELECT 
    patient_id, COUNT(*) AS visit_count
FROM
    appointments
GROUP BY patient_id
HAVING visit_count > 1 order by visit_count desc;

#Busiest day of the week
SELECT 
    DAYNAME(appointment_date) AS days,
    COUNT(*) AS total_appointments
FROM
    appointments
GROUP BY days
ORDER BY total_appointments DESC;

#Paitent with the most visits
SELECT 
    p.first_name, p.last_name, COUNT(*) AS total_visits
FROM
    appointments a
        JOIN
    patients p ON a.patient_id = p.patient_id
GROUP BY p.first_name , p.last_name
ORDER BY total_visits DESC
LIMIT 1;

#Gender distribution of patients
SELECT 
    gender, COUNT(*) AS Total_patients
FROM
    patients
GROUP BY gender;

#Treatment Count per type
SELECT 
    treatment_type, COUNT(*) AS total_treatment
FROM
    treatments
GROUP BY treatment_type
ORDER BY total_treatment DESC;
