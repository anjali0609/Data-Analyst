                                      #GENDER BASED#
#Task 1: patients distribution by gender

#Average billing Amount and Total_Revenue by gender
SELECT p.gender,round(SUM(b.amount),2) AS Total_Revenue, 
round(avg(b.amount),2) AS Average_Billing
FROM patients p JOIN billing b 
ON p.patient_id = b.patient_id
GROUP BY p.gender;

#All in one(patient,appointment,unique doc)
SELECT p.gender,
COUNT(DISTINCT p.patient_id) AS Total_patients,
COUNT(DISTINCT a.appointment_id) AS Total_appointments,
COUNT(DISTINCT a.doctor_id) AS Unique_doctors
FROM patients p LEFT JOIN appointments a 
ON p.patient_id = a.patient_id
GROUP BY p.gender;

#Treament types by gender
SELECT t.treatment_type,
sum(case when p.gender ="M" then 1 else 0 end) as Male,
sum(case when p.gender ="F" then 1 else 0 end) as Female
FROM patients p JOIN appointments a 
ON p.patient_id = a.patient_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY  t.treatment_type;



#Task :gender distribution by age group and total_revenue
SELECT SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) AS Male,
SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END) AS Female,
CASE WHEN TIMESTAMPDIFF(YEAR,p.date_of_birth,CURDATE()) BETWEEN 0 AND 17 THEN '0-17 (children)'
WHEN TIMESTAMPDIFF(YEAR,p.date_of_birth,CURDATE()) BETWEEN 18 AND 35 THEN '18-35 (young Adults)'
WHEN TIMESTAMPDIFF(YEAR,p.date_of_birth,CURDATE()) BETWEEN 36 AND 55 THEN '36-55 (Adults)'
ELSE '56+ (Seniors)' END AS Age_group,COUNT(*) AS Total_patients,SUM(b.amount) AS Total_Revenue
FROM patients p JOIN billing b ON p.patient_id = b.patient_id GROUP BY Age_group
ORDER BY Age_group;
                                              
                                              #PAYMENT METHOD BASED#
#count,total_revenue,total_taransactions,avg_bill of each payment
SELECT b.payment_method,SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) AS Male,
SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END) AS Female, 
COUNT(p.patient_id) AS Total_Transactions,
ROUND(SUM(amount), 2) AS Total_Revenue,ROUND(AVG(amount), 2) AS Avg_bill
FROM patients p JOIN billing b ON p.patient_id = b.patient_id
GROUP BY b.payment_method;

#bills stautus
SELECT distinct payment_method, 
SUM(CASE WHEN payment_status = 'Pending' THEN 1 ELSE 0 END) AS Pending_amount,
SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS Failed_amount,
SUM(CASE WHEN payment_status = 'Paid' THEN 1 ELSE 0 END) AS Paid_amount
FROM billing group by payment_method;
 
 #Payment status
SELECT DISTINCT
    payment_status,count(*) as No_of_Payments
FROM
    billing group by payment_status;

                                      #BASED ON DOCTORS#
 
 #total appointment per doct
 select d.doctor_id,concat(d.first_name," ",d.last_name) as Doctor_name,
 specialization , years_experience ,
 count(a.appointment_id) as Total_appointments,
 count(distinct a.patient_id) as Unique_Patients,
 round(sum(b.amount),2) as Total_Revenue
 from doctors d left join appointments a on d.doctor_id=a.doctor_id
 join billing b on a.patient_id=b.patient_id 
 group by d.doctor_id,Doctor_name,specialization,years_experience;
 
									#BASED ON BRANCH#
 
 select  d.hospital_branch,
 count(distinct a.patient_id) as unique_patients,
 count(distinct a.appointment_id) as Total_Appointments,
 count(distinct a.doctor_id) as active_doctors,
Round(sum(b.amount),2) as Total_Revenue,
 Round(Avg(b.amount),2) as Avg_bill_amount
 from appointments a left join
 billing b on a.patient_id=b.patient_id
 left join doctors d on a.doctor_id=d.doctor_id 
 group by d.hospital_branch;

                                  #BASED ON TIME AND DATE#
                                  
SELECT DAYNAME(appointment_date) AS Days,
COUNT(*) AS total_appointments
FROM appointments
GROUP BY Days;
                                  
SELECT monthname(appointment_date) AS Months,
COUNT(*) AS total_appointments
FROM appointments
GROUP BY Months;

                                   #cost by treatment type
select treatment_type,round(sum(cost),2) as Cost
from treatments group by treatment_type;

#doctors with year of experience
select  concat(first_name," ",last_name) as 
Doctor_name, years_experience
from doctors order by years_experience desc;