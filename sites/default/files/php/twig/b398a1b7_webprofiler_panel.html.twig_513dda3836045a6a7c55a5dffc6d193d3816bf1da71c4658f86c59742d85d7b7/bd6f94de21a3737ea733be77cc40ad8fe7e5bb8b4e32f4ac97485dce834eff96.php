<?php

/* modules/devel/webprofiler/templates/Profiler/webprofiler_panel.html.twig */
class __TwigTemplate_e488f8cfb1e98f71e62d729b2a74345a6f858e81e8e466a1cb4afabde6b516bb extends Twig_Template
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
        $__internal_623a0d74eab547b941409c8cb935ba43eba148a3185ab81a53995def817cd395 = $this->env->getExtension("native_profiler");
        $__internal_623a0d74eab547b941409c8cb935ba43eba148a3185ab81a53995def817cd395->enter($__internal_623a0d74eab547b941409c8cb935ba43eba148a3185ab81a53995def817cd395_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/devel/webprofiler/templates/Profiler/webprofiler_panel.html.twig"));

        $tags = array();
        $filters = array("raw" => 1);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array(),
                array('raw'),
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
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar((isset($context["panel"]) ? $context["panel"] : null)));
        echo "
";
        
        $__internal_623a0d74eab547b941409c8cb935ba43eba148a3185ab81a53995def817cd395->leave($__internal_623a0d74eab547b941409c8cb935ba43eba148a3185ab81a53995def817cd395_prof);

    }

    public function getTemplateName()
    {
        return "modules/devel/webprofiler/templates/Profiler/webprofiler_panel.html.twig";
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
/* {{ panel|raw }}*/
/* */
