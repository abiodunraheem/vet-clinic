/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name varchar(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL NOT NULL
);

-- Add a column species of type string to your animals table
ALTER TABLE animals ADD species VARCHAR(100); 

-- Create owners table
CREATE TABLE owners (
id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
full_name VARCHAR(250) NOT NULL,
age INT NOT NULL
);

-- Create species table
CREATE TABLE species (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL
);

-- Remove column species
ALTER TABLE animals DROP species;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD CONSTRAINT species_id FOREIGN KEY(species_id) REFERENCES species(id);

-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals ADD owner_id INT;
ALTER TABLE animals ADD CONSTRAINT owner_id FOREIGN KEY(owner_id) REFERENCES owners(id);

-- Create a table named vets with the following columns
CREATE TABLE vets (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL
);

-- Specialization table
CREATE TABLE specializations (
   id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
   vets_id INT NOT NULL,
   species_id INT NOT NULL,
   FOREIGN KEY(vets_id) REFERENCES vets(id) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Visit table
CREATE TABLE visits (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    vets_id INT NOT NULL,
    animals_id INT NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY(vets_id) REFERENCES vets(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY(animals_id) REFERENCES animals(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

EXPLAIN ANALYZE SELECT COUNT(*) FROM visits WHERE animals_id = 4
SELECT * FROM visits WHERE vets_id = 2;
SELECT * FROM owners WHERE email = 'owner_18327@mail.com';

-- Way to decrease the time exec for the fisrt query
CREATE INDEX animals_id_index ON visits(animals_id);
SELECT COUNT(*) FROM visits WHERE animals_id = 4

-- Way to improve execution time of the other two queries.
CREATE INDEX visits_id_index ON visits(vets_id);
SELECT * FROM visits WHERE vets_id = 2;

CREATE INDEX owners_id_index ON owners(email);
SELECT * FROM owners WHERE email = 'owner_18327@mail.com';

EXPLAIN ANALYZE SELECT * FROM visits WHERE animals_id = 2;

EXPLAIN ANALYZE SELECT * FROM owners WHERE email = 'owner_18327@mail.com';
