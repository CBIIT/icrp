<?php

/* {# inline_template_start #}destination=/faq */
class __TwigTemplate_851134ce3d64ba9bf29e015ffbe49e84c49a299c8c94944e9eaaa238f7ef85c4 extends Twig_Template
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
        $__internal_0dd017d00e38aac79e5264bb86e05c3ce3ef1e42a6b7eb9008b505b2e871fec7 = $this->env->getExtension("native_profiler");
        $__internal_0dd017d00e38aac79e5264bb86e05c3ce3ef1e42a6b7eb9008b505b2e871fec7->enter($__internal_0dd017d00e38aac79e5264bb86e05c3ce3ef1e42a6b7eb9008b505b2e871fec7_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "{# inline_template_start #}destination=/faq"));

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
        echo "destination=/faq";
        
        $__internal_0dd017d00e38aac79e5264bb86e05c3ce3ef1e42a6b7eb9008b505b2e871fec7->leave($__internal_0dd017d00e38aac79e5264bb86e05c3ce3ef1e42a6b7eb9008b505b2e871fec7_prof);

    }

    public function getTemplateName()
    {
        return "{# inline_template_start #}destination=/faq";
    }

    public function getDebugInfo()
    {
        return array (  46 => 1,);
    }
}
/* {# inline_template_start #}destination=/faq*/
