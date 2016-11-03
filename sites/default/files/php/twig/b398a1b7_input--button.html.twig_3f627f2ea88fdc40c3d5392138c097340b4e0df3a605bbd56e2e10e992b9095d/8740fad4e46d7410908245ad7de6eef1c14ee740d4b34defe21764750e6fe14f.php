<?php

/* themes/bootstrap/templates/input/input--button.html.twig */
class __TwigTemplate_3b48b97bc72a8530620ab6ae5b4013093fd7ac0faf98bf518f39e6bd8ddaba1d extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        // line 1
        $this->parent = $this->loadTemplate("input.html.twig", "themes/bootstrap/templates/input/input--button.html.twig", 1);
        $this->blocks = array(
            'input' => array($this, 'block_input'),
        );
    }

    protected function doGetParent(array $context)
    {
        return "input.html.twig";
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $__internal_3d62dd2c9eef1bf2075487b2660d617ad0a70e09bd26bbaa43f05ea0d238310a = $this->env->getExtension("native_profiler");
        $__internal_3d62dd2c9eef1bf2075487b2660d617ad0a70e09bd26bbaa43f05ea0d238310a->enter($__internal_3d62dd2c9eef1bf2075487b2660d617ad0a70e09bd26bbaa43f05ea0d238310a_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/input/input--button.html.twig"));

        $tags = array("spaceless" => 25, "set" => 27, "if" => 34);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('spaceless', 'set', 'if'),
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

        // line 25
        ob_start();
        // line 27
        $context["classes"] = array(0 => "btn", 1 => (((        // line 29
(isset($context["type"]) ? $context["type"] : null) == "submit")) ? ("js-form-submit") : ("")), 2 => ((((        // line 30
(isset($context["icon"]) ? $context["icon"] : null) && (isset($context["icon_position"]) ? $context["icon_position"] : null)) &&  !(isset($context["icon_only"]) ? $context["icon_only"] : null))) ? (("icon-" . (isset($context["icon_position"]) ? $context["icon_position"] : null))) : ("")));
        echo trim(preg_replace('/>\s+</', '><', ob_get_clean()));
        // line 1
        $this->parent->display($context, array_merge($this->blocks, $blocks));
        
        $__internal_3d62dd2c9eef1bf2075487b2660d617ad0a70e09bd26bbaa43f05ea0d238310a->leave($__internal_3d62dd2c9eef1bf2075487b2660d617ad0a70e09bd26bbaa43f05ea0d238310a_prof);

    }

    // line 33
    public function block_input($context, array $blocks = array())
    {
        $__internal_9bdcf14a43be2d46a9b5535e4bbe879865085a6aedcb7211c2ce25c0651fdc67 = $this->env->getExtension("native_profiler");
        $__internal_9bdcf14a43be2d46a9b5535e4bbe879865085a6aedcb7211c2ce25c0651fdc67->enter($__internal_9bdcf14a43be2d46a9b5535e4bbe879865085a6aedcb7211c2ce25c0651fdc67_prof = new Twig_Profiler_Profile($this->getTemplateName(), "block", "input"));

        // line 34
        echo "    ";
        if ((isset($context["icon_only"]) ? $context["icon_only"] : null)) {
            // line 35
            echo "      <button";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null), 1 => "icon-only"), "method"), "html", null, true));
            echo ">
        <span class=\"sr-only\">";
            // line 36
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["label"]) ? $context["label"] : null), "html", null, true));
            echo "</span>
        ";
            // line 37
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["icon"]) ? $context["icon"] : null), "html", null, true));
            echo "
      </button>
    ";
        } else {
            // line 40
            echo "      ";
            if (((isset($context["icon_position"]) ? $context["icon_position"] : null) == "after")) {
                // line 41
                echo "        <button";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
                echo ">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["label"]) ? $context["label"] : null), "html", null, true));
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["icon"]) ? $context["icon"] : null), "html", null, true));
                echo "</button>";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["children"]) ? $context["children"] : null), "html", null, true));
                echo "
      ";
            } else {
                // line 43
                echo "        <button";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
                echo ">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["icon"]) ? $context["icon"] : null), "html", null, true));
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["label"]) ? $context["label"] : null), "html", null, true));
                echo "</button>";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["children"]) ? $context["children"] : null), "html", null, true));
                echo "
      ";
            }
            // line 45
            echo "    ";
        }
        // line 46
        echo "    ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["children"]) ? $context["children"] : null), "html", null, true));
        echo "
  ";
        
        $__internal_9bdcf14a43be2d46a9b5535e4bbe879865085a6aedcb7211c2ce25c0651fdc67->leave($__internal_9bdcf14a43be2d46a9b5535e4bbe879865085a6aedcb7211c2ce25c0651fdc67_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/input/input--button.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  118 => 46,  115 => 45,  104 => 43,  93 => 41,  90 => 40,  84 => 37,  80 => 36,  75 => 35,  72 => 34,  66 => 33,  59 => 1,  56 => 30,  55 => 29,  54 => 27,  52 => 25,  11 => 1,);
    }
}
/* {% extends "input.html.twig" %}*/
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme suggestion for "button" input form element.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: A list of HTML attributes for the input element.*/
/*  * - children: Optional additional rendered elements.*/
/*  * - icon: An icon.*/
/*  * - icon_only: Flag to display only the icon and not the label.*/
/*  * - icon_position: Where an icon should be displayed.*/
/*  * - label: button label.*/
/*  * - prefix: Markup to display before the input element.*/
/*  * - suffix: Markup to display after the input element.*/
/*  * - type: The type of input.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see \Drupal\bootstrap\Plugin\Preprocess\InputButton*/
/*  * @see \Drupal\bootstrap\Plugin\Preprocess\Input*/
/*  * @see template_preprocess_input()*/
/*  *//* */
/* #}*/
/* {% spaceless %}*/
/*   {%*/
/*     set classes = [*/
/*       'btn',*/
/*       type == 'submit' ? 'js-form-submit',*/
/*       icon and icon_position and not icon_only ? 'icon-' ~ icon_position,*/
/*     ]*/
/*   %}*/
/*   {% block input %}*/
/*     {% if icon_only %}*/
/*       <button{{ attributes.addClass(classes, 'icon-only') }}>*/
/*         <span class="sr-only">{{ label }}</span>*/
/*         {{ icon }}*/
/*       </button>*/
/*     {% else %}*/
/*       {% if icon_position == 'after' %}*/
/*         <button{{ attributes.addClass(classes) }}>{{ label }}{{ icon }}</button>{{ children }}*/
/*       {% else %}*/
/*         <button{{ attributes.addClass(classes) }}>{{ icon }}{{ label }}</button>{{ children }}*/
/*       {% endif %}*/
/*     {% endif %}*/
/*     {{ children }}*/
/*   {% endblock %}*/
/* {% endspaceless %}*/
/* */
