/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name varchar(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL NOT NULL
)

-- Add a column species of type string to your animals table
ALTER TABLE animals ADD species VARCHAR(100);

Create owners table
CREATE TABLE owners (
id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
full_name VARCHAR(250) NOT NULL,
age INT NOT NULL
);

Create species table
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

/* Populate database with sample data. */

INSERT INTO animals ( name, date_of_birth, escape_attempts, neutered, weight_kg )
VALUES ('Agumon', '2020-02-03', 0, true, 10.23),
       ('Gabumon', '2018-11-15', 2, true, 8),
       ('Pikachu', '2021-01-07', 1, false, 15.04),
       ('Devimon', '2017-05-12', 5, true, 11),
       ('Charmander', '2020-02-08', 0, false, -11),
       ('Plantmon', '2021-11-15', 2, true, -5.7),
       ('Squirtle', '1993-04-02', 3, false, -12.13),
       ('Angemon', '2005-06-12', 1, true, -45),
       ('Boarmon', '2005-06-07', 7, true, 20.4),
       ('Blossom', '1998-10-13', 3, true, 17),
       ('Ditto', '2022-05-14', 4, true, 22);

-- Insert data into owners table
INSERT INTO owners ( full_name, age )
VALUES ('Sam Smith', 34),
       ('Jennifer Orwell', 19),
       ('Bob', 45),
       ('Melody Pond', 77),
       ('Dean Winchester', 14),
       ('Jodie Whittaker', 38);

-- Insert data into species table
INSERT INTO species (name)
VALUES ('Pokemon'),
       ('Digimon');

-- Modify your inserted animals so it includes the species_id value
-- If the name ends in "mon" it will be Digimon while all other animals will be Pokemon
UPDATE animals SET species_id = ( SELECT id FROM species WHERE name= 'Digimon' )
    WHERE name LIKE '%mon';
    SELECT * FROM animals;

UPDATE animals SET species_id = ( SELECT id FROM species WHERE name ='Pokemon' ) 
WHERE name NOT LIKE '%mon';
SELECT * FROM animals;

-- Modify your inserted animals to include owner information (owner_id)

-- Sam Smith owns Agumon
UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Sam Smith')
WHERE name = 'Agumon';

-- Jennifer Orwell owns Gabumon and Pikachu
UPDATE animals SET owner_id = ( SELECT id FROM owners WHERE full_name = 'Jennifer Orwell' )
WHERE name = 'Gabumon' AND name = 'Pikachu';

-- Bob owns Devimon and Plantmon.
UPDATE animals SET owner_id = ( SELECT id FROM owners WHERE full_name = 'Bob' )
WHERE name = 'Devimon' AND name = 'Plantmon';

-- Melody Pond owns Charmander, Squirtle, and Blossom.
UPDATE animals SET owner_id = ( SELECT id FROM owners WHERE full_name = 'Melody Pond' )
WHERE name = 'Blossom' AND name = 'Squirtle' AND name = 'Charmander';

-- Dean Winchester owns Angemon and Boarmon.
UPDATE animals SET owner_id = ( SELECT id FROM owners WHERE full_name ='Dean Winchester' )
WHERE name = 'Angemon' AND name = 'Boarmon';

-- Insert the following data for vet
INSERT INTO vets (name, age, date_of_graduation)
VALUES('William Tatcher', 45, '2000-04-23'),
      ('Maisy Smith', 26, '2019-01-17'),
      ('Stephanie Mendez', 64, '1981-05-04'),
      ('Jack Harkness', 38, '2008-06-08');

--Insert the following data for specialties:

-- Vet William Tatcher is specialized in Pokemon.
-- Vet Stephanie Mendez is specialized in Digimon and Pokemon.
-- Vet Jack Harkness is specialized in Digimon

-- INSERT INTO specializations (vets_id, species_id)
VALUES (1, 1),
       (3, 2),
       (3, 1),
       (4, 2);

-- Insert the following data for visits:

-- Agumon visited William Tatcher on May 24th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM animals WHERE name = 'Agumon'),
    (SELECT id FROM vets WHERE name = 'William Tatcher'),
    '2020-05-24'
);

-- Agumon visited Stephanie Mendez on Jul 22th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM animals WHERE name = 'Agumon'),
    (SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
    '2020-07-22'
);

-- Gabumon visited Jack Harkness on Feb 2nd, 2021.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM animals WHERE name = 'Gabumon'),
    (SELECT id FROM vets WHERE name = 'Jack Harkness'),
    '2021-02-02'
);

-- Pikachu visited Maisy Smith on Jan 5th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM animals WHERE name = 'Pikachu'),
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    '2020-01-05'
);

-- Pikachu visited Maisy Smith on Mar 8th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM animals WHERE name = 'Pikachu'),
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    '2020-03-08'
);

-- Pikachu visited Maisy Smith on May 14th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM animals WHERE name = 'Pikachu'),
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    '2020-05-14'
);

-- Devimon visited Stephanie Mendez on May 4th, 2021.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM animals WHERE name = 'Devimon'),
    (SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
    '2021-05-04'
);

-- Charmander visited Jack Harkness on Feb 24th, 2021.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM vets WHERE name = 'Jack Harkness'),
    (SELECT id FROM animals WHERE name = 'Charmander'),
    '2021-02-24'
);

-- Plantmon visited Maisy Smith on Dec 21st, 2019.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    (SELECT id FROM animals WHERE name = 'Plantmon'),
    '2019-12-21'
);

-- Plantmon visited William Tatcher on Aug 10th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM vets WHERE name = 'William Tatcher'),
    (SELECT id FROM animals WHERE name = 'Plantmon'),
    '2020-08-10'
);

-- Plantmon visited Maisy Smith on Apr 7th, 2021.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    (SELECT id FROM animals WHERE name = 'Plantmon'),
    '2021-04-07'
);

-- Squirtle visited Stephanie Mendez on Sep 29th, 2019.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
    (SELECT id FROM animals WHERE name = 'Squirtle'),
    '2019-09-29'
);

-- Angemon visited Jack Harkness on Oct 3rd, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (  
    (SELECT id FROM vets WHERE name = 'Jack Harkness'),
    (SELECT id FROM animals WHERE name = 'Angemon'),
    '2020-10-03'
);

-- Angemon visited Jack Harkness on Nov 4th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (   
    (SELECT id FROM vets WHERE name = 'Jack Harkness'),
    (SELECT id FROM animals WHERE name = 'Angemon'),
    '2020-11-04'
);

-- Boarmon visited Maisy Smith on Jan 24th, 2019.
INSERT INTO visits (vets_id, animals_id, date) VALUES (    
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    (SELECT id FROM animals WHERE name = 'Boarmon'),
    '2019-01-24'
);

-- Boarmon visited Maisy Smith on May 15th, 2019.
INSERT INTO visits (vets_id, animals_id, date) VALUES (   
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    (SELECT id FROM animals WHERE name = 'Boarmon'),
    '2019-05-15'
);

-- Boarmon visited Maisy Smith on Feb 27th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    (SELECT id FROM animals WHERE name = 'Boarmon'),
    '2020-02-27'
);

-- Boarmon visited Maisy Smith on Aug 3rd, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES (
    (SELECT id FROM vets WHERE name = 'Maisy Smith'),
    (SELECT id FROM animals WHERE name = 'Boarmon'),
    '2020-08-03'
);

-- Blossom visited Stephanie Mendez on May 24th, 2020.
INSERT INTO visits (vets_id, animals_id, date) VALUES ( 
    (SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
    (SELECT id FROM animals WHERE name = 'Blossom'),
    '2020-05-24'
);

-- Blossom visited William Tatcher on Jan 11th, 2021.
INSERT INTO visits (vets_id, animals_id, date) VALUES (   
    (SELECT id FROM vets WHERE name = 'William Tatcher'),
    (SELECT id FROM animals WHERE name = 'Blossom'),
    '2021-01-11'
);

-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (vets_id, animals_id, date) SELECT * FROM (SELECT id FROM vets) vets_id, (SELECT id FROM animals) animals_id, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>', 'age = Owner age, and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, age, email) select 'Owner ' || generate_series(1,2500000), age, 'owner_' || generate_series(1,2500000) || '@mail.com' from owners;

