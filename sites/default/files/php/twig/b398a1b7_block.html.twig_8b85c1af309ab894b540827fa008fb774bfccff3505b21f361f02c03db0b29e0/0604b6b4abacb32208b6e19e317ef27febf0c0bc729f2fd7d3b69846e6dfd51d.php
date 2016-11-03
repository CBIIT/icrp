<?php

/* themes/bootstrap/templates/block/block.html.twig */
class __TwigTemplate_855930e6e076de62cf4dc8440bd460a9fcba7a201edae7e66d9ecc0f67487aa9 extends Twig_Template
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
        $__internal_984e557714db0a08b8988b3e9b545697e64884b12020ff156d9fb9c61d0d7248 = $this->env->getExtension("native_profiler");
        $__internal_984e557714db0a08b8988b3e9b545697e64884b12020ff156d9fb9c61d0d7248->enter($__internal_984e557714db0a08b8988b3e9b545697e64884b12020ff156d9fb9c61d0d7248_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/block/block.html.twig"));

        $tags = array("set" => 49, "if" => 58, "block" => 63);
        $filters = array("clean_class" => 51);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'if', 'block'),
                array('clean_class'),
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

        // line 49
        $context["classes"] = array(0 => "block", 1 => ("block-" . \Drupal\Component\Utility\Html::getClass($this->getAttribute(        // line 51
(isset($context["configuration"]) ? $context["configuration"] : null), "provider", array()))), 2 => ("block-" . \Drupal\Component\Utility\Html::getClass(        // line 52
(isset($context["plugin_id"]) ? $context["plugin_id"] : null))), 3 => "clearfix");
        // line 56
        echo "<section";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
        echo ">
  ";
        // line 57
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title_prefix"]) ? $context["title_prefix"] : null), "html", null, true));
        echo "
  ";
        // line 58
        if ((isset($context["label"]) ? $context["label"] : null)) {
            // line 59
            echo "    <h2";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["title_attributes"]) ? $context["title_attributes"] : null), "addClass", array(0 => "block-title"), "method"), "html", null, true));
            echo ">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["label"]) ? $context["label"] : null), "html", null, true));
            echo "</h2>
  ";
        }
        // line 61
        echo "  ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title_suffix"]) ? $context["title_suffix"] : null), "html", null, true));
        echo "

  ";
        // line 63
        $this->displayBlock('content', $context, $blocks);
        // line 66
        echo "</section>

";
        
        $__internal_984e557714db0a08b8988b3e9b545697e64884b12020ff156d9fb9c61d0d7248->leave($__internal_984e557714db0a08b8988b3e9b545697e64884b12020ff156d9fb9c61d0d7248_prof);

    }

    // line 63
    public function block_content($context, array $blocks = array())
    {
        $__internal_9f1a3df8e8539872cf7f77d472e347bd1c68a8d3c09754996b00ccd7f3719c33 = $this->env->getExtension("native_profiler");
        $__internal_9f1a3df8e8539872cf7f77d472e347bd1c68a8d3c09754996b00ccd7f3719c33->enter($__internal_9f1a3df8e8539872cf7f77d472e347bd1c68a8d3c09754996b00ccd7f3719c33_prof = new Twig_Profiler_Profile($this->getTemplateName(), "block", "content"));

        // line 64
        echo "    ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
        echo "
  ";
        
        $__internal_9f1a3df8e8539872cf7f77d472e347bd1c68a8d3c09754996b00ccd7f3719c33->leave($__internal_9f1a3df8e8539872cf7f77d472e347bd1c68a8d3c09754996b00ccd7f3719c33_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/block/block.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  93 => 64,  87 => 63,  78 => 66,  76 => 63,  70 => 61,  62 => 59,  60 => 58,  56 => 57,  51 => 56,  49 => 52,  48 => 51,  47 => 49,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display a block.*/
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
/* {%*/
/*   set classes = [*/
/*     'block',*/
/*     'block-' ~ configuration.provider|clean_class,*/
/*     'block-' ~ plugin_id|clean_class,*/
/*     'clearfix',*/
/*   ]*/
/* %}*/
/* <section{{ attributes.addClass(classes) }}>*/
/*   {{ title_prefix }}*/
/*   {% if label %}*/
/*     <h2{{ title_attributes.addClass('block-title') }}>{{ label }}</h2>*/
/*   {% endif %}*/
/*   {{ title_suffix }}*/
/* */
/*   {% block content %}*/
/*     {{ content }}*/
/*   {% endblock %}*/
/* </section>*/
/* */
/* */
