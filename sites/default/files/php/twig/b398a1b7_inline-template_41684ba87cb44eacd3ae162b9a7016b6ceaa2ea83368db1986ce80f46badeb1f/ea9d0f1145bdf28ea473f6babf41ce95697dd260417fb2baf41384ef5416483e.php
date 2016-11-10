<?php

/* {# inline_template_start #}<p>{{ message }}</p> */
class __TwigTemplate_3eca5deba32ac68e58b264eebd81271c3842a0ed2d1a36329cada598b7c1ea97 extends Twig_Template
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
        $__internal_a88210319cdf67ec3f302dd4371e198170e6040296ae02fe677309869522e1dc = $this->env->getExtension("native_profiler");
        $__internal_a88210319cdf67ec3f302dd4371e198170e6040296ae02fe677309869522e1dc->enter($__internal_a88210319cdf67ec3f302dd4371e198170e6040296ae02fe677309869522e1dc_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "{# inline_template_start #}<p>{{ message }}</p>"));

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

        // line 1
        echo "<p>";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["message"]) ? $context["message"] : null), "html", null, true));
        echo "</p>";
        
        $__internal_a88210319cdf67ec3f302dd4371e198170e6040296ae02fe677309869522e1dc->leave($__internal_a88210319cdf67ec3f302dd4371e198170e6040296ae02fe677309869522e1dc_prof);

    }

    public function getTemplateName()
    {
        return "{# inline_template_start #}<p>{{ message }}</p>";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  46 => 1,);
    }
}
/* {# inline_template_start #}<p>{{ message }}</p>*/
