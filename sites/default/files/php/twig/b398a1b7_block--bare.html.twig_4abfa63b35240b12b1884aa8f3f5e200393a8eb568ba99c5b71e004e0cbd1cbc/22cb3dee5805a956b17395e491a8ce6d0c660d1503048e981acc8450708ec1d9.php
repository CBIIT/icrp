<?php

/* block--bare.html.twig */
class __TwigTemplate_3ced684f54e2ebf87442efdb289ccaf635856a70f79d7839e9f9c7d33d6148f3 extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
            'content' => array($this, 'block_content'),
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $__internal_7fed29fef65e8f62c6ef29afd869fc409d2573a45a85f5b2272485a0b1c1325d = $this->env->getExtension("native_profiler");
        $__internal_7fed29fef65e8f62c6ef29afd869fc409d2573a45a85f5b2272485a0b1c1325d->enter($__internal_7fed29fef65e8f62c6ef29afd869fc409d2573a45a85f5b2272485a0b1c1325d_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "block--bare.html.twig"));

        $tags = array("block" => 48);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('block'),
                array(),
                array()
            );
        } catch (Twig_Sandbox_SecurityError $e) {
            $e->setTemplateFile($this->getTemplateName());

            if ($e instanceof Twig_Sandbox_SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

        // line 48
        $this->displayBlock('content', $context, $blocks);
        
        $__internal_7fed29fef65e8f62c6ef29afd869fc409d2573a45a85f5b2272485a0b1c1325d->leave($__internal_7fed29fef65e8f62c6ef29afd869fc409d2573a45a85f5b2272485a0b1c1325d_prof);

    }

    public function block_content($context, array $blocks = array())
    {
        $__internal_1dc46353a5c5ac6855aaed4146c7c789acff849e0309aaf6724c9081af5035a3 = $this->env->getExtension("native_profiler");
        $__internal_1dc46353a5c5ac6855aaed4146c7c789acff849e0309aaf6724c9081af5035a3->enter($__internal_1dc46353a5c5ac6855aaed4146c7c789acff849e0309aaf6724c9081af5035a3_prof = new Twig_Profiler_Profile($this->getTemplateName(), "block", "content"));

        // line 49
        echo "  ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
        echo "
";
        
        $__internal_1dc46353a5c5ac6855aaed4146c7c789acff849e0309aaf6724c9081af5035a3->leave($__internal_1dc46353a5c5ac6855aaed4146c7c789acff849e0309aaf6724c9081af5035a3_prof);

    }

    public function getTemplateName()
    {
        return "block--bare.html.twig";
    }

    public function getDebugInfo()
    {
        return array (  59 => 49,  47 => 48,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display a bare minimum block.*/
/*  **/
/*  * Available variables:*/
/*  * - $block->subject: Block title.*/
/*  * - $content: Block content.*/
/*  * - $block->module: Module that generated the block.*/
/*  * - $block->delta: An ID for the block, unique within each module.*/
/*  * - $block->region: The block region embedding the current block.*/
/*  * - $classes: String of classes that can be used to style contextually through*/
/*  *   CSS. It can be manipulated through the variable $classes_array from*/
/*  *   preprocess functions. The default values can be one or more of the*/
/*  *   following:*/
/*  *   - block: The current template type, i.e., "theming hook".*/
/*  *   - block-[module]: The module generating the block. For example, the user*/
/*  *     module is responsible for handling the default user navigation block. In*/
/*  *     that case the class would be 'block-user'.*/
/*  * - $title_prefix (array): An array containing additional output populated by*/
/*  *   modules, intended to be displayed in front of the main title tag that*/
/*  *   appears in the template.*/
/*  * - $title_suffix (array): An array containing additional output populated by*/
/*  *   modules, intended to be displayed after the main title tag that appears in*/
/*  *   the template.*/
/*  **/
/*  * Helper variables:*/
/*  * - $classes_array: Array of html class attribute values. It is flattened*/
/*  *   into a string within the variable $classes.*/
/*  * - $block_zebra: Outputs 'odd' and 'even' dependent on each block region.*/
/*  * - $zebra: Same output as $block_zebra but independent of any block region.*/
/*  * - $block_id: Counter dependent on each block region.*/
/*  * - $id: Same output as $block_id but independent of any block region.*/
/*  * - $is_front: Flags true when presented in the front page.*/
/*  * - $logged_in: Flags true when the current user is a logged-in member.*/
/*  * - $is_admin: Flags true when the current user is an administrator.*/
/*  * - $block_html_id: A valid HTML ID and guaranteed unique.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see bootstrap_preprocess_block()*/
/*  * @see template_preprocess()*/
/*  * @see template_preprocess_block()*/
/*  * @see bootstrap_process_block()*/
/*  * @see template_process()*/
/*  *//* */
/* #}*/
/* {% block content %}*/
/*   {{ content }}*/
/* {% endblock %}*/
/* */
