<?php

/* themes/bootstrap/templates/system/container.html.twig */
class __TwigTemplate_ba8069e6611515e68fc01b6642efe428793cd6b04e662bfc083c5cf850e399fa extends Twig_Template
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
        $__internal_0addc318abb04020d332f4233f401375509b12f1ac9acbda6207c4c8e1f1bc3f = $this->env->getExtension("native_profiler");
        $__internal_0addc318abb04020d332f4233f401375509b12f1ac9acbda6207c4c8e1f1bc3f->enter($__internal_0addc318abb04020d332f4233f401375509b12f1ac9acbda6207c4c8e1f1bc3f_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/system/container.html.twig"));

        $tags = array("set" => 23);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set'),
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

        // line 23
        $context["classes"] = array(0 => (( !$this->getAttribute(        // line 24
(isset($context["attributes"]) ? $context["attributes"] : null), "hasClass", array(0 => "toolbar-menu-administration"), "method")) ? ("form-group") : ("")), 1 => ((        // line 25
(isset($context["has_parent"]) ? $context["has_parent"] : null)) ? ("js-form-wrapper") : ("")), 2 => ((        // line 26
(isset($context["has_parent"]) ? $context["has_parent"] : null)) ? ("form-wrapper") : ("")));
        // line 29
        echo "<div";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
        echo ">";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["children"]) ? $context["children"] : null), "html", null, true));
        echo "</div>
";
        
        $__internal_0addc318abb04020d332f4233f401375509b12f1ac9acbda6207c4c8e1f1bc3f->leave($__internal_0addc318abb04020d332f4233f401375509b12f1ac9acbda6207c4c8e1f1bc3f_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/system/container.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  51 => 29,  49 => 26,  48 => 25,  47 => 24,  46 => 23,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override of a container used to wrap child elements.*/
/*  **/
/*  * Used for grouped form items. Can also be used as a theme wrapper for any*/
/*  * renderable element, to surround it with a <div> and HTML attributes.*/
/*  * See the @link forms_api_reference.html Form API reference @endlink for more*/
/*  * information on the #theme_wrappers render array property.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes for the containing element.*/
/*  * - children: The rendered child elements of the container.*/
/*  * - has_parent: A flag to indicate that the container has one or more parent*/
/*  *   containers.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_container()*/
/*  *//* */
/* #}*/
/* {%*/
/*   set classes = [*/
/*     not attributes.hasClass('toolbar-menu-administration') ? 'form-group',*/
/*     has_parent ? 'js-form-wrapper',*/
/*     has_parent ? 'form-wrapper',*/
/*   ]*/
/* %}*/
/* <div{{ attributes.addClass(classes) }}>{{ children }}</div>*/
/* */
