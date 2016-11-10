<?php

/* modules/ds/templates/ds-entity-view.html.twig */
class __TwigTemplate_516ee5edbe935682b8832107e5322b51010b5c35b2753283d36adc21b95ab89b extends Twig_Template
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
        $__internal_4cc841ffcc91b17c7476421d23808483bba6ce8bc0e7acec9f2216bd7ea92abe = $this->env->getExtension("native_profiler");
        $__internal_4cc841ffcc91b17c7476421d23808483bba6ce8bc0e7acec9f2216bd7ea92abe->enter($__internal_4cc841ffcc91b17c7476421d23808483bba6ce8bc0e7acec9f2216bd7ea92abe_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/ds/templates/ds-entity-view.html.twig"));

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

        // line 10
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
        echo "
";
        
        $__internal_4cc841ffcc91b17c7476421d23808483bba6ce8bc0e7acec9f2216bd7ea92abe->leave($__internal_4cc841ffcc91b17c7476421d23808483bba6ce8bc0e7acec9f2216bd7ea92abe_prof);

    }

    public function getTemplateName()
    {
        return "modules/ds/templates/ds-entity-view.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  46 => 10,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Display Entity View*/
/*  **/
/*  * Available variables:*/
/*  * - content: The render array which contains the layout*/
/*  *//* */
/* #}*/
/* {{ content }}*/
/* */
