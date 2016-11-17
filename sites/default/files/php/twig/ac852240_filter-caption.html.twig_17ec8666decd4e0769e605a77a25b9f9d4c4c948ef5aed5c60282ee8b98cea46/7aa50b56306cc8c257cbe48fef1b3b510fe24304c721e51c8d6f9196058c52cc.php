<?php

/* core/modules/filter/templates/filter-caption.html.twig */
class __TwigTemplate_0333b9bbb0fdf6ba7d203b0ac7505964f44890a58e2ea03a0a824e96e4bfaf7e extends Twig_Template
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
        $__internal_29a932b17458fa06db982f7e875c9ac14f844b75d94e377f30ee2322de5f6383 = $this->env->getExtension("native_profiler");
        $__internal_29a932b17458fa06db982f7e875c9ac14f844b75d94e377f30ee2322de5f6383->enter($__internal_29a932b17458fa06db982f7e875c9ac14f844b75d94e377f30ee2322de5f6383_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/filter/templates/filter-caption.html.twig"));

        $tags = array("if" => 15);
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

        // line 15
        echo "<figure role=\"group\"";
        if ((isset($context["classes"]) ? $context["classes"] : null)) {
            echo " class=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["classes"]) ? $context["classes"] : null), "html", null, true));
            echo "\"";
        }
        echo ">
";
        // line 16
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["node"]) ? $context["node"] : null), "html", null, true));
        echo "
<figcaption>";
        // line 17
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["caption"]) ? $context["caption"] : null), "html", null, true));
        echo "</figcaption>
</figure>
";
        
        $__internal_29a932b17458fa06db982f7e875c9ac14f844b75d94e377f30ee2322de5f6383->leave($__internal_29a932b17458fa06db982f7e875c9ac14f844b75d94e377f30ee2322de5f6383_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/filter/templates/filter-caption.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  59 => 17,  55 => 16,  46 => 15,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for a filter caption.*/
/*  **/
/*  * Returns HTML for a captioned image, audio, video or other tag.*/
/*  **/
/*  * Available variables*/
/*  * - string node: The complete HTML tag whose contents are being captioned.*/
/*  * - string tag: The name of the HTML tag whose contents are being captioned.*/
/*  * - string caption: The caption text.*/
/*  * - string classes: The classes of the captioned HTML tag.*/
/*  *//* */
/* #}*/
/* <figure role="group"{%- if classes %} class="{{ classes }}"{%- endif %}>*/
/* {{ node }}*/
/* <figcaption>{{ caption }}</figcaption>*/
/* </figure>*/
/* */
