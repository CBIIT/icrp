Frequently Asked Questions
==============================
The Frequently Asked Questions (faq) module allows users, 
with appropriate permissions, to create question and answer 
pairs which they want displayed on the 'faq' page. The 'faq' 
page is automatically generated from the FAQ nodes configured. 

### Installation
1. Copy faq folder to [drupalinstallationrootfolder]/modules directory.
2. At admin/modules enable the FAQ module.
3. Set permissions at admin/people/permissions#module-faq
4. Configure the module at admin/config/content/faq
5. Your FAQ-s are available at /faq-page and /faq-page/{taxonomy**termid} depends on the settings at the previous point.

Note: this is a dev version, tested on the drupal 8.0.x-dev core.

### Features
The layout of the FAQ page can be modified on the settings page. There are four question and answer layouts to choose from. In addition, if the 'Taxonomy' module is enabled, it is possible to put the questions into different categories when editing. Users will need the 'view faq page' permission to view the built-in 'faq' page and will need the 'administer faq' permission to configure the layout, etc.
There is a block included in this module: FAQ categories shows FAQ-related taxonomy terms in a block.

### General settings tab
In this page you can set the FAQ Page title, description and use custom breadcrumbs or not. These settings wil be shown on every FAQ Page, breadcrumbs are build by categories.

### Questions settings tab
Page layout determines how to render a FAQ page:
* **Questions inline**: the answer is directly below the question
* **Clicking on question takes user to answer futher down the page**: on the top of the page there is a ‘table of content’ and then the question-answers
* **Clicking on question opens/hides answer under question**: the answer is hidden by default, collapse all/expand all links provided
* **Clicking on question opens the answer in a new page**: answer is not listed on the page, just a link to the content

In miscellaneous layout settings you can set the listing style, you can label the questions and answers.

The Quesions length determines how the questions are shown on pages. From node edit form you can disable ‘detailed question’ by checking off the ‘Allow long question text to be configured’.
Another oppurtunities: use accordion effect for ‘open/hide’ layout, use answer teasers insted of full nodes, you can show or hide node links and disable linking to the quesion node. You can also set the ‘back to top’ text and give a default sorting to the nodes.

### Category settings tab
In this page you can configure how to categorize the questions. The common in this layouts is that we can distinguish two page: the simple /faq-page and a category view on /faq-page/{termid} url. On the simple faq-page there is a hierarchical category list and on the category view the FAQs of the current category ans subcategories are listed. The available categories layouts:
* **Don’t display**: in this case on the simple /faq-page site there are no categories listed, but the category views are still available in /faq-page/{termid} form.
* **Categories inline**: on the top of the page there is a table of contents structured by the categories.
* **Clicking on category opens/hides question and answers under category**
* **Clicking on category opens the questions/answers in a new page**: in this case questions layout setting won’t affect the site’s layout.

### Ordering FAQs
On the /faq-page/order or /faq-page/{termid}/order there is the oppurtunity to add custom ordering to the questions. These settings are distinguished by categories, so if a question is a member of more categories, you can order categories separately.
