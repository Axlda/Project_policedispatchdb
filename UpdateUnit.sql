-- UPDATE Statement: Used by dispatchers to update a unit's availability status when they clear a scene.
UPDATE PATROL_UNIT 
SET Availability_Status = 'Available' 
WHERE Unit_ID = 'Car-205';