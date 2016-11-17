<?php

/* core/modules/views/templates/views-view-field.html.twig */
class __TwigTemplate_80c2c23e9e63a7c7c88ab720f49ec7948adf1cf3d7fe9da3c949a39d80532c14 extends Twig_Template
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
        $__internal_75754caaadf0b65eca2de8995ae3e532bb06a9f5039305d0dadb1d60d7d923b1 = $this->env->getExtension("native_profiler");
        $__internal_75754caaadf0b65eca2de8995ae3e532bb06a9f5039305d0dadb1d60d7d923b1->enter($__internal_75754caaadf0b65eca2de8995ae3e532bb06a9f5039305d0dadb1d60d7d923b1_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/views/templates/views-view-field.html.twig"));

        $tags = array();
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array(),
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

        // line 23
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["output"]) ? $context["output"] : null), "html", null, true));
        
        $__internal_75754caaadf0b65eca2de8995ae3e532bb06a9f5039305d0dadb1d60d7d923b1->leave($__internal_75754caaadf0b65eca2de8995ae3e532bb06a9f5039305d0dadb1d60d7d923b1_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/views/templates/views-view-field.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  46 => 23,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for a single field in a view.*/
/*  **/
/*  * Available variables:*/
/*  * - view: The view that the field belongs to.*/
/*  * - field: The field handler that can process the input.*/
/*  * - row: The raw result of the database query that generated this field.*/
/*  * - output: The processed output that will normally be used.*/
/*  **/
/*  * When fetching output from the row this construct should be used:*/
/*  * data = row[field.field_alias]*/
/*  **/
/*  * The above will guarantee that you'll always get the correct data, regardless*/
/*  * of any changes in the aliasing that might happen if the view is modified.*/
/*  **/
/*  * @see template_preprocess_views_view_field()*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* {{ output -}}*/
/* */
