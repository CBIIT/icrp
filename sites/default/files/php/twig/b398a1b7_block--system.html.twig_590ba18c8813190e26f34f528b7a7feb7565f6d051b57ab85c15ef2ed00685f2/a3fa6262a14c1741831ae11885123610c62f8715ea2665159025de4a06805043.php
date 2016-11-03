<?php

/* themes/bootstrap/templates/block/block--system.html.twig */
class __TwigTemplate_e056532b9aef62006933e45a578998faec3bb2a41272314ebc078949afe24de7 extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        // line 9
        $this->parent = $this->loadTemplate("block--bare.html.twig", "themes/bootstrap/templates/block/block--system.html.twig", 9);
        $this->blocks = array(
        );
    }

    protected function doGetParent(array $context)
    {
        return "block--bare.html.twig";
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $__internal_4cb5a6c646b20de1a57b2fd9300f9807f532f12b3a3a4f993c0cab106f163922 = $this->env->getExtension("native_profiler");
        $__internal_4cb5a6c646b20de1a57b2fd9300f9807f532f12b3a3a4f993c0cab106f163922->enter($__internal_4cb5a6c646b20de1a57b2fd9300f9807f532f12b3a3a4f993c0cab106f163922_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/block/block--system.html.twig"));

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

        $this->parent->display($context, array_merge($this->blocks, $blocks));
        
        $__internal_4cb5a6c646b20de1a57b2fd9300f9807f532f12b3a3a4f993c0cab106f163922->leave($__internal_4cb5a6c646b20de1a57b2fd9300f9807f532f12b3a3a4f993c0cab106f163922_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/block/block--system.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  11 => 9,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override for system blocks.*/
/*  **/
/*  * @ingroup templates*/
/*  *//* */
/* #}*/
/* {% extends "block--bare.html.twig" %}*/
/* */
