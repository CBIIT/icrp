<?php

/* modules/entity_embed/templates/entity-embed-container.html.twig */
class __TwigTemplate_44ad3c8f047f468557a3c268bf418761833305f349d900ed875af3c683dccc59 extends Twig_Template
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
        $__internal_6a46d02fc413727a953bc0457198972579a7f8633f878d42cbea6dc6d6c395c9 = $this->env->getExtension("native_profiler");
        $__internal_6a46d02fc413727a953bc0457198972579a7f8633f878d42cbea6dc6d6c395c9->enter($__internal_6a46d02fc413727a953bc0457198972579a7f8633f878d42cbea6dc6d6c395c9_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/entity_embed/templates/entity-embed-container.html.twig"));

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
        
        $__internal_6a46d02fc413727a953bc0457198972579a7f8633f878d42cbea6dc6d6c395c9->leave($__internal_6a46d02fc413727a953bc0457198972579a7f8633f878d42cbea6dc6d6c395c9_prof);

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
