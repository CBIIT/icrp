<?php

/* core/modules/image/templates/image-formatter.html.twig */
class __TwigTemplate_70b2f7e292f0719d51699712854da982c1c8e70dd9319cf0d7c10fdb700dac36 extends Twig_Template
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
        $__internal_18584d52b77f2ef9f61529e108a64583803aeca2410782797e9f8d74cad19414 = $this->env->getExtension("native_profiler");
        $__internal_18584d52b77f2ef9f61529e108a64583803aeca2410782797e9f8d74cad19414->enter($__internal_18584d52b77f2ef9f61529e108a64583803aeca2410782797e9f8d74cad19414_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/image/templates/image-formatter.html.twig"));

        $tags = array("if" => 16);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if'),
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

        // line 16
        if ((isset($context["url"]) ? $context["url"] : null)) {
            // line 17
            echo "  <a href=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["url"]) ? $context["url"] : null), "html", null, true));
            echo "\">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["image"]) ? $context["image"] : null), "html", null, true));
            echo "</a>
";
        } else {
            // line 19
            echo "  ";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["image"]) ? $context["image"] : null), "html", null, true));
            echo "
";
        }
        
        $__internal_18584d52b77f2ef9f61529e108a64583803aeca2410782797e9f8d74cad19414->leave($__internal_18584d52b77f2ef9f61529e108a64583803aeca2410782797e9f8d74cad19414_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/image/templates/image-formatter.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  56 => 19,  48 => 17,  46 => 16,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display a formatted image field.*/
/*  **/
/*  * Available variables:*/
/*  * - image: A collection of image data.*/
/*  * - image_style: An optional image style.*/
/*  * - url: An optional URL the image can be linked to.*/
/*  **/
/*  * @see template_preprocess_image_formatter()*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* {% if url %}*/
/*   <a href="{{ url }}">{{ image }}</a>*/
/* {% else %}*/
/*   {{ image }}*/
/* {% endif %}*/
/* */
