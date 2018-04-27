--
-- Update slideshow content
--

UPDATE `node__body`
    SET body_value = '<p>Over $50 billion in cancer research funding from <span data-count="funding-organizations"></span> organizations around the world</p>'
    WHERE entity_id = 28;

UPDATE `node_revision__body`
    SET body_value = '<p>Over $50 billion in cancer research funding from <span data-count="funding-organizations"></span> organizations around the world</p>'
    WHERE entity_id = 28;


UPDATE `node__body`
    SET body_value = '<p>Explore our research database of over <span data-count="rounded-projects">80,000</span> awards</p>',
        body_format = 'full_html'
    WHERE entity_id = 29;

UPDATE `node_revision__body`
    SET body_value = '<p>Explore our research database of over <span data-count="rounded-projects">80,000</span> awards</p>',
        body_format = 'full_html'
    WHERE entity_id = 29;

