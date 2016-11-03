<?php

/* themes/bootstrap/templates/system/image.html.twig */
class __TwigTemplate_2d1ab100917f778f1f324c85d072fee67ceb0fd6d63a60c5f56f5072120ac4ca extends Twig_Template
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
        $__internal_59168bec5745ebec4aeae5f001d7c7495ac4cf30e5234dfd10dcd54bd0e82fb4 = $this->env->getExtension("native_profiler");
        $__internal_59168bec5745ebec4aeae5f001d7c7495ac4cf30e5234dfd10dcd54bd0e82fb4->enter($__internal_59168bec5745ebec4aeae5f001d7c7495ac4cf30e5234dfd10dcd54bd0e82fb4_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/system/image.html.twig"));

        $tags = array("set" => 15);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set'),
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

        // line 15
        $context["classes"] = array(0 => (($this->getAttribute($this->getAttribute(        // line 16
(isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "image_shape", array())) ? ($this->getAttribute($this->getAttribute((isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "image_shape", array())) : ("")), 1 => (($this->getAttribute($this->getAttribute(        // line 17
(isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "image_responsive", array())) ? ("img-responsive") : ("")));
        // line 19
        echo "<img";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
        echo " />
";
        
        $__internal_59168bec5745ebec4aeae5f001d7c7495ac4cf30e5234dfd10dcd54bd0e82fb4->leave($__internal_59168bec5745ebec4aeae5f001d7c7495ac4cf30e5234dfd10dcd54bd0e82fb4_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/system/image.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  50 => 19,  48 => 17,  47 => 16,  46 => 15,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation of an image.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes for the img tag.*/
/*  * - style_name: (optional) The name of the image style applied.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_image()*/
/*  *//* */
/* #}*/
/* {% set classes = [*/
/*   theme.settings.image_shape ? theme.settings.image_shape,*/
/*   theme.settings.image_responsive ? 'img-responsive',*/
/* ] %}*/
/* <img{{ attributes.addClass(classes) }} />*/
/* */
