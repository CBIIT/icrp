--
-- Insert User library access - everyone
--
INSERT INTO  user__field_library_access (`bundle`,`deleted`,`entity_id`,`revision_id`,`langcode`,`delta`,`field_library_access_value`)
SELECT DISTINCT ur.bundle, ur.deleted, ur.entity_id, ur.revision_id, 'en', 0, 'general' FROM users u
JOIN user__roles ur ON u.uid = ur.entity_id;

--
-- Insert User library access - manager, administrator
--
INSERT INTO  user__field_library_access (`bundle`,`deleted`,`entity_id`,`revision_id`,`langcode`,`delta`,`field_library_access_value`)
SELECT DISTINCT ur.bundle, ur.deleted, ur.entity_id, ur.revision_id, ur.langcode, 1, 'finance' FROM users u
JOIN user__roles ur ON u.uid = ur.entity_id
WHERE ur.roles_target_id in ('manager', 'administrator');

INSERT INTO  user__field_library_access (`bundle`,`deleted`,`entity_id`,`revision_id`,`langcode`,`delta`,`field_library_access_value`)
SELECT DISTINCT ur.bundle, ur.deleted, ur.entity_id, ur.revision_id, ur.langcode, 2, 'operations_and_contracts' FROM users u
JOIN user__roles ur ON u.uid = ur.entity_id
WHERE ur.roles_target_id in ('manager', 'administrator');