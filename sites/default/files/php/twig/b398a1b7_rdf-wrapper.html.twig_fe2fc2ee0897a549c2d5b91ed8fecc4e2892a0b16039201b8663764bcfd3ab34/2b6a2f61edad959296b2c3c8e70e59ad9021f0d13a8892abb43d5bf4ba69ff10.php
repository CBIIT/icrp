<?php

/* core/modules/rdf/templates/rdf-wrapper.html.twig */
class __TwigTemplate_0e1606f74cc3c46689897deab8115147a9c4fe5c83a7715707578f4bf45e0f7a extends Twig_Template
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
        $__internal_ab49ef323e48e01fc97aea662de57f9b927e13e083de51cde5395f5224bf6adf = $this->env->getExtension("native_profiler");
        $__internal_ab49ef323e48e01fc97aea662de57f9b927e13e083de51cde5395f5224bf6adf->enter($__internal_ab49ef323e48e01fc97aea662de57f9b927e13e083de51cde5395f5224bf6adf_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/rdf/templates/rdf-wrapper.html.twig"));

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

        // line 13
        echo "<span";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["attributes"]) ? $context["attributes"] : null), "html", null, true));
        echo ">";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
        echo "</span>
";
        
        $__internal_ab49ef323e48e01fc97aea662de57f9b927e13e083de51cde5395f5224bf6adf->leave($__internal_ab49ef323e48e01fc97aea662de57f9b927e13e083de51cde5395f5224bf6adf_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/rdf/templates/rdf-wrapper.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  46 => 13,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for wrapping content with RDF attributes.*/
/*  **/
/*  * Available variables:*/
/*  * - content: The content being wrapped with RDF attributes.*/
/*  * - attributes: HTML attributes, including RDF attributes for wrapper element.*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* <span{{ attributes }}>{{ content }}</span>*/
/* */
