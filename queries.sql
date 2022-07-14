/*Queries that provide answers to the questions from all projects.*/

SELECT *  FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';
SELECT name FROM animals WHERE neutered=true AND escape_attempts < 3;
SELECT date_of_birth from animals WHERE name ='Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered=true;
SELECT * FROM animals WHERE NOT name='Gabumon';
SELECT * FROM animals WHERE weight_kg >= '10.4' and weight_kg <='17.3';

-- Update the animals table by setting the species column to unspecified
BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;
SELECT * FROM animals

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS null;
COMMIT;
SELECT * FROM animals;

-- Delete all records in the animals table, then roll back the transaction.
BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

-- Delete all animals born after Jan 1st, 2022
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT DELETE_ANIMALS_AFTER2022;
UPDATE animals SET weight_kg = weight_kg * (-1);
ROLLBACK TO DELETE_ANIMALS_AFTER2022;
UPDATE animals SET weight_kg = weight_kg * (-1) WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;

-- Write queries to answer the following questions:

    -- How many animals are there?
    SELECT (COUNT*) as total_animals FROM animals;
    -- How many animals have never tried to escape?
    SELECT (COUNT*) as zero_escape_attempts FROM animals WHERE escape_attempts = '0';
    -- What is the average weight of animals?
    SELECT AVG(weight_kg) as average_weight_kg FROM animals;
    -- Who escapes the most, neutered or not neutered animals?
    SELECT neutered, MAX(escape_attempts) FROM ANIMALS GROUP BY neutered; 
    -- What is the minimum and maximum weight of each type of animal?
    SELECT MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
    -- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
    SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth  BETWEEN '1990-01-01' AND '2000-01-01' GROUP BY species;

-- Write queries (using JOIN) to answer the following questions: 

    -- What animals belong to Melody Pond?
    SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id AND owners.full_name = 'Melody Pond';
    -- List of all animals that are pokemon (their type is Pokemon).
    SELECT * FROM animals JOIN species ON animals.species_id = species.id AND species.name = 'pokemon';
    -- List all owners and their animals, remember to include those that don't own any animal.
    SELECT * FROM animals RIGHT JOIN owners ON animals.owner_id = owners.id; 
    -- How many animals are there per species?
    SELECT COUNT(*), species.name FROM animals JOIN species on animals.species_id = species.id GROUP BY species.id; 
    -- List all Digimon owned by Jennifer Orwell.
    SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id JOIN species ON animals.species_id = species.id AND owners.full_name = 'Jennifer Orwell' AND species.name ='Digimon';
    -- List all animals owned by Dean Winchester that haven't tried to escape.
    SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id and owners.full_name ='Dean Winchester' and animals.escape_attempts = 0;
    -- Who owns the most animals?
    SELECT owners.full_name, COUNT(animals) FROM owners JOIN animals ON owners.id = animals.owner_id GROUP BY owners.full_name ORDER BY COUNT(animals) DESC LIMIT 1;