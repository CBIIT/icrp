<?php

/* themes/bootstrap/templates/input/form-element-label.html.twig */
class __TwigTemplate_6f0309ddfbb0623f2c1aa2582cd00749bd3296607ef996a3819d6e78584f46c1 extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $tags = array("set" => 20, "if" => 28);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'if'),
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

        // line 20
        $context["classes"] = array(0 => "control-label", 1 => (((        // line 22
(isset($context["title_display"]) ? $context["title_display"] : null) == "after")) ? ("option") : ("")), 2 => (((        // line 23
(isset($context["title_display"]) ? $context["title_display"] : null) == "invisible")) ? ("sr-only") : ("")), 3 => ((        // line 24
(isset($context["required"]) ? $context["required"] : null)) ? ("js-form-required") : ("")), 4 => ((        // line 25
(isset($context["required"]) ? $context["required"] : null)) ? ("form-required") : ("")));
        // line 28
        if ( !twig_test_empty((isset($context["title"]) ? $context["title"] : null))) {
            // line 29
            echo "<label";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
            echo ">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["element"]) ? $context["element"] : null), "html", null, true));
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title"]) ? $context["title"] : null), "html", null, true));
            // line 30
            if ((isset($context["description"]) ? $context["description"] : null)) {
                // line 31
                echo "<p class=\"help-block\">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["description"]) ? $context["description"] : null), "html", null, true));
                echo "</p>";
            }
            // line 33
            echo "</label>";
        }
    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/input/form-element-label.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  64 => 33,  59 => 31,  57 => 30,  51 => 29,  49 => 28,  47 => 25,  46 => 24,  45 => 23,  44 => 22,  43 => 20,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for a form element label.*/
/*  **/
/*  * Available variables:*/
/*  * - element: an input element.*/
/*  * - title: The label's text.*/
/*  * - title_display: Elements title_display setting.*/
/*  * - description: element description.*/
/*  * - required: An indicator for whether the associated form element is required.*/
/*  * - attributes: A list of HTML attributes for the label.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_form_element_label()*/
/*  *//* */
/* #}*/
/* {%-*/
/*   set classes = [*/
/*     'control-label',*/
/*     title_display == 'after' ? 'option',*/
/*     title_display == 'invisible' ? 'sr-only',*/
/*     required ? 'js-form-required',*/
/*     required ? 'form-required',*/
/*   ]*/
/* -%}*/
/* {%- if title is not empty -%}*/
/*   <label{{ attributes.addClass(classes) }}>{{ element }}{{ title }}*/
/*     {%- if description -%}*/
/*       <p class="help-block">{{ description }}</p>*/
/*     {%- endif -%}*/
/*   </label>*/
/* {%- endif -%}*/
/* */
