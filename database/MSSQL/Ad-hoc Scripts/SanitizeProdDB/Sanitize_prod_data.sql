
UPDATE users_field_data AS u
INNER JOIN user__roles AS ur ON u.uid = ur.entity_id 
SET u.status=0
WHERE ur.roles_target_id  <> "administrator";

UPDATE user__field_membership_status AS m
INNER JOIN user__roles AS ur ON m.entity_id = ur.entity_id 
SET m.field_membership_status_value="blocked"
WHERE ur.roles_target_id <> "administrator";


UPDATE icrp.users_field_data
SET mail = CONCAT("icrpdummy", "+", uid, "@gmail.com"), 
    init = CONCAT("icrpdummy", "+", uid, "@gmail.com"),
    name = CONCAT("icrpdummy", "+", uid)
WHERE uid > 5;

UPDATE user__field_first_name
SET field_first_name_value = "ICRP"
WHERE entity_id > 5;

UPDATE user__field_last_name
SET field_last_name_value = CONCAT("Dummy", entity_id) 
WHERE entity_id > 5;
