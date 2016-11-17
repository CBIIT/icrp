<?php

/* themes/bootstrap_subtheme/templates/blocks/block--search.html.twig */
class __TwigTemplate_d6e4a4d8dd7feaa379b984afa77daf26e3a98d813fae496975fe7015d057b0fc extends Twig_Template
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
        $__internal_ab5524d2b9703550e3a75d54b42b228720c15e1e8eef94478defb6370bf2b47c = $this->env->getExtension("native_profiler");
        $__internal_ab5524d2b9703550e3a75d54b42b228720c15e1e8eef94478defb6370bf2b47c->enter($__internal_ab5524d2b9703550e3a75d54b42b228720c15e1e8eef94478defb6370bf2b47c_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap_subtheme/templates/blocks/block--search.html.twig"));

        $tags = array("set" => 38, "if" => 46, "block" => 51);
        $filters = array("clean_class" => 40);
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

        // line 38
        $context["classes"] = array(0 => "block", 1 => ("block-" . \Drupal\Component\Utility\Html::getClass($this->getAttribute(        // line 40
(isset($context["configuration"]) ? $context["configuration"] : null), "provider", array()))), 2 => ("block-" . \Drupal\Component\Utility\Html::getClass(        // line 41
(isset($context["plugin_id"]) ? $context["plugin_id"] : null))));
        // line 44
        echo "<div";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
        echo ">
  ";
        // line 45
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title_prefix"]) ? $context["title_prefix"] : null), "html", null, true));
        echo "
  ";
        // line 46
        if ((isset($context["label"]) ? $context["label"] : null)) {
            // line 47
            echo "    <h2";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["title_attributes"]) ? $context["title_attributes"] : null), "addClass", array(0 => "visually-hidden"), "method"), "html", null, true));
            echo ">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["label"]) ? $context["label"] : null), "html", null, true));
            echo "</h2>
  ";
        }
        // line 49
        echo "  ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title_suffix"]) ? $context["title_suffix"] : null), "html", null, true));
        echo "
  <div class=\"well col-sm-4 search-well\">
    ";
        // line 51
        $this->displayBlock('content', $context, $blocks);
        // line 54
        echo "  </div>
</div>
";
        
        $__internal_ab5524d2b9703550e3a75d54b42b228720c15e1e8eef94478defb6370bf2b47c->leave($__internal_ab5524d2b9703550e3a75d54b42b228720c15e1e8eef94478defb6370bf2b47c_prof);

    }

    // line 51
    public function block_content($context, array $blocks = array())
    {
        $__internal_e71104700066cbfc4c63ebae844dea441bcebb3670ce63c4050d6be21686a327 = $this->env->getExtension("native_profiler");
        $__internal_e71104700066cbfc4c63ebae844dea441bcebb3670ce63c4050d6be21686a327->enter($__internal_e71104700066cbfc4c63ebae844dea441bcebb3670ce63c4050d6be21686a327_prof = new Twig_Profiler_Profile($this->getTemplateName(), "block", "content"));

        // line 52
        echo "      ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
        echo "
    ";
        
        $__internal_e71104700066cbfc4c63ebae844dea441bcebb3670ce63c4050d6be21686a327->leave($__internal_e71104700066cbfc4c63ebae844dea441bcebb3670ce63c4050d6be21686a327_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap_subtheme/templates/blocks/block--search.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  93 => 52,  87 => 51,  78 => 54,  76 => 51,  70 => 49,  62 => 47,  60 => 46,  56 => 45,  51 => 44,  49 => 41,  48 => 40,  47 => 38,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display a search block.*/
/*  **/
/*  * Available variables:*/
/*  * - plugin_id: The ID of the block implementation.*/
/*  * - label: The configured label of the block if visible.*/
/*  * - configuration: A list of the block's configuration values.*/
/*  *   - label: The configured label for the block.*/
/*  *   - label_display: The display settings for the label.*/
/*  *   - module: The module that provided this block plugin.*/
/*  *   - cache: The cache settings.*/
/*  *   - Block plugin specific settings will also be stored here.*/
/*  * - block - The full block entity.*/
/*  *   - label_hidden: The hidden block title value if the block was*/
/*  *     configured to hide the title ('label' is empty in this case).*/
/*  *   - module: The module that generated the block.*/
/*  *   - delta: An ID for the block, unique within each module.*/
/*  *   - region: The block region embedding the current block.*/
/*  * - content: The content of this block.*/
/*  * - attributes: array of HTML attributes populated by modules, intended to*/
/*  *   be added to the main container tag of this template.*/
/*  *   - id: A valid HTML ID and guaranteed unique.*/
/*  * - title_attributes: Same as attributes, except applied to the main title*/
/*  *   tag that appears in the template.*/
/*  * - title_prefix: Additional output populated by modules, intended to be*/
/*  *   displayed in front of the main title tag that appears in the template.*/
/*  * - title_suffix: Additional output populated by modules, intended to be*/
/*  *   displayed after the main title tag that appears in the template.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_block()*/
/*  *//* */
/* #}*/
/* {%*/
/*   set classes = [*/
/*     'block',*/
/*     'block-' ~ configuration.provider|clean_class,*/
/*     'block-' ~ plugin_id|clean_class,*/
/*   ]*/
/* %}*/
/* <div{{ attributes.addClass(classes) }}>*/
/*   {{ title_prefix }}*/
/*   {% if label %}*/
/*     <h2{{ title_attributes.addClass('visually-hidden') }}>{{ label }}</h2>*/
/*   {% endif %}*/
/*   {{ title_suffix }}*/
/*   <div class="well col-sm-4 search-well">*/
/*     {% block content %}*/
/*       {{ content }}*/
/*     {% endblock %}*/
/*   </div>*/
/* </div>*/
/* */
