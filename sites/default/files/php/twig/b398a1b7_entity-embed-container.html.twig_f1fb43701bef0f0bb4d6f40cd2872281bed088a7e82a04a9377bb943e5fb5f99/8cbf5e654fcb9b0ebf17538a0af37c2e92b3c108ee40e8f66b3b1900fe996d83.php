<?php

/* modules/entity_embed/templates/entity-embed-container.html.twig */
class __TwigTemplate_ea36a375cfa1f0480d1fdaea40ab3d216ca79d97c36ee40344e718bbe899d427 extends Twig_Template
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
        $__internal_30236847940e29457888fb861e5c955f5261e273f3dfaa962a21b01c1eb3cb51 = $this->env->getExtension("native_profiler");
        $__internal_30236847940e29457888fb861e5c955f5261e273f3dfaa962a21b01c1eb3cb51->enter($__internal_30236847940e29457888fb861e5c955f5261e273f3dfaa962a21b01c1eb3cb51_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/entity_embed/templates/entity-embed-container.html.twig"));

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

        // line 15
        echo "<article";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["attributes"]) ? $context["attributes"] : null), "html", null, true));
        echo ">";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["children"]) ? $context["children"] : null), "html", null, true));
        echo "</article>
";
        
        $__internal_30236847940e29457888fb861e5c955f5261e273f3dfaa962a21b01c1eb3cb51->leave($__internal_30236847940e29457888fb861e5c955f5261e273f3dfaa962a21b01c1eb3cb51_prof);

    }

    public function getTemplateName()
    {
        return "modules/entity_embed/templates/entity-embed-container.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  46 => 15,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation of a container used to wrap embedded entities.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes for the containing element.*/
/*  * - children: The rendered child elements of the container.*/
/*  **/
/*  * @see template_preprocess_entity_embed_container()*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* <article{{ attributes }}>{{ children }}</article>*/
/* */
