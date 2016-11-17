<?php

/* core/modules/rdf/templates/rdf-metadata.html.twig */
class __TwigTemplate_49a27d69ed6711124360d5e9bdce801f0c0cc8c91003c5f5b521948dce7320b8 extends Twig_Template
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
        $__internal_98b41b110c341d73c79de32aa061160b1af2e67ec70599dee59f500c0030a690 = $this->env->getExtension("native_profiler");
        $__internal_98b41b110c341d73c79de32aa061160b1af2e67ec70599dee59f500c0030a690->enter($__internal_98b41b110c341d73c79de32aa061160b1af2e67ec70599dee59f500c0030a690_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/rdf/templates/rdf-metadata.html.twig"));

        $tags = array("for" => 20);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('for'),
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
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable((isset($context["metadata"]) ? $context["metadata"] : null));
        foreach ($context['_seq'] as $context["_key"] => $context["attributes"]) {
            // line 21
            echo "  <span";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["attributes"], "addClass", array(0 => "hidden"), "method"), "html", null, true));
            echo "></span>
";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['attributes'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        
        $__internal_98b41b110c341d73c79de32aa061160b1af2e67ec70599dee59f500c0030a690->leave($__internal_98b41b110c341d73c79de32aa061160b1af2e67ec70599dee59f500c0030a690_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/rdf/templates/rdf-metadata.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  50 => 21,  46 => 20,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for empty spans with RDF attributes.*/
/*  **/
/*  * The XHTML+RDFa doctype allows either <span></span> or <span /> syntax to*/
/*  * be used, but for maximum browser compatibility, W3C recommends the*/
/*  * former when serving pages using the text/html media type, see*/
/*  * http://www.w3.org/TR/xhtml1/#C_3.*/
/*  **/
/*  * Available variables:*/
/*  * - metadata: Each item within corresponds to its own set of attributes,*/
/*  *   and therefore, needs its own 'attributes' element.*/
/*  **/
/*  * @see template_preprocess_rdf_metadata()*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* {% for attributes in metadata %}*/
/*   <span{{ attributes.addClass('hidden') }}></span>*/
/* {% endfor %}*/
/* */
