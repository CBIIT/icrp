<?php

/* core/modules/image/templates/image-style.html.twig */
class __TwigTemplate_611406b269de7d3e424524f123be11185ad117c36335e6bf9087f4de4cae766d extends Twig_Template
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
        $__internal_a94044490aa44bc1b76d3c236a81678208106dbc9623290ff1cdfe6140829d4c = $this->env->getExtension("native_profiler");
        $__internal_a94044490aa44bc1b76d3c236a81678208106dbc9623290ff1cdfe6140829d4c->enter($__internal_a94044490aa44bc1b76d3c236a81678208106dbc9623290ff1cdfe6140829d4c_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/image/templates/image-style.html.twig"));

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

        // line 20
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["image"]) ? $context["image"] : null), "html", null, true));
        echo "
";
        
        $__internal_a94044490aa44bc1b76d3c236a81678208106dbc9623290ff1cdfe6140829d4c->leave($__internal_a94044490aa44bc1b76d3c236a81678208106dbc9623290ff1cdfe6140829d4c_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/image/templates/image-style.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  46 => 20,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for an image using a specific image style.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes for the image, including the following:*/
/*  *   - src: Full URL or relative path to the image file.*/
/*  *   - class: One or more classes to be applied to the image.*/
/*  *   - width: The width of the image (if known).*/
/*  *   - height: The height of the image (if known).*/
/*  *   - title: The title of the image.*/
/*  *   - alt: The alternative text for the image.*/
/*  **/
/*  * @see template_preprocess_image_style()*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* {{ image }}*/
/* */
