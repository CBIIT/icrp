<?php

/* core/themes/stable/templates/admin/image-resize-summary.html.twig */
class __TwigTemplate_6aded9b918f6500333214e62a9501b2dc3824e2755aa6461fc561a9c70b48bc5 extends Twig_Template
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
        $tags = array("if" => 16, "trans" => 20);
        $filters = array("e" => 17);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if', 'trans'),
                array('e'),
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
        if (($this->getAttribute((isset($context["data"]) ? $context["data"] : null), "width", array()) && $this->getAttribute((isset($context["data"]) ? $context["data"] : null), "height", array()))) {
            // line 17
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["data"]) ? $context["data"] : null), "width", array())));
            echo "×";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["data"]) ? $context["data"] : null), "height", array())));
        } else {
            // line 19
            if ($this->getAttribute((isset($context["data"]) ? $context["data"] : null), "width", array())) {
                // line 20
                echo "    ";
                echo t("width @data.width", array("@data.width" => $this->getAttribute(                // line 21
(isset($context["data"]) ? $context["data"] : null), "width", array()), ));
                // line 23
                echo "  ";
            } elseif ($this->getAttribute((isset($context["data"]) ? $context["data"] : null), "height", array())) {
                // line 24
                echo "    ";
                echo t("height @data.height", array("@data.height" => $this->getAttribute(                // line 25
(isset($context["data"]) ? $context["data"] : null), "height", array()), ));
                // line 27
                echo "  ";
            }
        }
    }

    public function getTemplateName()
    {
        return "core/themes/stable/templates/admin/image-resize-summary.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  63 => 27,  61 => 25,  59 => 24,  56 => 23,  54 => 21,  52 => 20,  50 => 19,  45 => 17,  43 => 16,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override for a summary of an image resize effect.*/
/*  **/
/*  * Available variables:*/
/*  * - data: The current configuration for this resize effect, including:*/
/*  *   - width: The width of the resized image.*/
/*  *   - height: The height of the resized image.*/
/*  * - effect: The effect information, including:*/
/*  *   - id: The effect identifier.*/
/*  *   - label: The effect name.*/
/*  *   - description: The effect description.*/
/*  *//* */
/* #}*/
/* {% if data.width and data.height -%}*/
/*   {{ data.width|e }}×{{ data.height|e }}*/
/* {%- else -%}*/
/*   {% if data.width %}*/
/*     {% trans %}*/
/*       width {{ data.width|e }}*/
/*     {% endtrans %}*/
/*   {% elseif data.height %}*/
/*     {% trans %}*/
/*       height {{ data.height|e }}*/
/*     {% endtrans %}*/
/*   {% endif %}*/
/* {%- endif %}*/
/* */
