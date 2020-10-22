
-- Only execute this on dev/test site to revert previous implementation
-- Remove block for "About Us" if it exists
SELECT id FROM block_content_field_data
  WHERE info = 'About Us' LIMIT 1
  INTO @block_id;

DELETE FROM block_content WHERE id = @block_id;
DELETE FROM block_content__body WHERE entity_id  = @block_id;
DELETE FROM block_content_field_data WHERE id = @block_id;
DELETE FROM block_content_field_revision WHERE id = @block_id;
DELETE FROM block_content_revision WHERE id = @block_id;
DELETE FROM block_content_revision__body WHERE entity_id = @block_id;
DELETE FROM config WHERE name = 'block.block.aboutus';

-- Remove block for "Edit About Us Button" if it exists
SELECT id FROM block_content_field_data
  WHERE info = 'Edit About Us Button' LIMIT 1
  INTO @block_id;

DELETE FROM block_content WHERE id = @block_id;
DELETE FROM block_content__body WHERE entity_id  = @block_id;
DELETE FROM block_content_field_data WHERE id = @block_id;
DELETE FROM block_content_field_revision WHERE id = @block_id;
DELETE FROM block_content_revision WHERE id = @block_id;
DELETE FROM block_content_revision__body WHERE entity_id = @block_id;
DELETE FROM config WHERE name = 'block.block.editaboutusbutton';