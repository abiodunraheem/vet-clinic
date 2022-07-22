-- Create database for a clinic
CREATE DATABASE clinic;

-- table for patient
 CREATE TABLE patients ( 
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200),
        date_of_birth DATE
    );

-- Table for medical histories
    CREATE TABLE medical_histories ( 
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        admitted_at TIMESTAMP,
        patient_id INT,
        status VARCHAR(20),
        CONSTRAINT fk_patient_id 
            FOREIGN KEY (patient_id) 
            REFERENCES patients(id) 
            ON DELETE CASCADE
    );

-- Create table for treatments
    CREATE TABLE treatments ( 
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        type VARCHAR(200),
        name VARCHAR(200)
    );

-- Create table for treatments_histories
    CREATE TABLE treatments_histories ( 
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        medical_history_id INT,
        treatment_id INT,
        CONSTRAINT fk_medical_history_id 
            FOREIGN KEY (medical_history_id) 
            REFERENCES medical_histories(id) 
            ON DELETE CASCADE,
        CONSTRAINT fk_treatment_id 
            FOREIGN KEY (treatment_id) 
            REFERENCES treatments(id) 
            ON DELETE CASCADE
    );

-- Create table for invoices
    CREATE TABLE invoices ( 
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        total_amount DECIMAL,
        generated_at TIMESTAMP,
        payed_at TIMESTAMP,
        medical_history_id INT,
        CONSTRAINT unique_history_id 
                UNIQUE(medical_history_id),
        CONSTRAINT fk_medical_history_id 
            FOREIGN KEY (medical_history_id) 
            REFERENCES medical_histories(id) 
            ON DELETE CASCADE
    );

-- Create table for invoice_item
     CREATE TABLE invoice_items ( 
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        unit_price DECIMAL,
        quantity INT,
        total_price DECIMAL,
        invoice_id INT,
        treatment_id INT,
        CONSTRAINT fk_invoices_id 
            FOREIGN KEY (invoice_id) 
            REFERENCES invoices(id) 
            ON DELETE CASCADE,
        CONSTRAINT fk_treatment_id 
            FOREIGN KEY (treatment_id) 
            REFERENCES treatments(id) 
            ON DELETE CASCADE
    );

-- Improve execusion time
CREATE INDEX  patient_id_index ON medical_histories(patient_id);
CREATE INDEX  invoice_id_index ON invoice_items(invoice_id);
CREATE INDEX  treatment_id_index ON invoice_items(treatment_id);
CREATE INDEX  medical_id_index ON invoices(medical_history_id);
CREATE INDEX  treatment_id_history_index ON treatments_histories(treatment_id);
CREATE INDEX  medical_history_id_index ON treatments_histories(medical_history_id);