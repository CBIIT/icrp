--
-- Addes a check to all users for the Partners News and Announcement Forum
--
INSERT IGNORE user__field_subcommittee_partner_news (bundle, entity_id, revision_id, langcode, delta, field_subcommittee_partner_news_value) SELECT 'user', uid, uid, 'en', 0, 1 FROM users WHERE uid > 0;

--
--  To remove all you can TRUNCATE the table with the following command.
-- TRUNCATE user__field_subcommittee_partner_news 
--