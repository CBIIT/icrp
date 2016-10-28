<?php

/* modules/sitemap/templates/sitemap-feed-icon.html.twig */
class __TwigTemplate_797fcd2e3a3fc723042a169b2b52f5f59dc7e2ce5eaf0e2ad3292867184c0536 extends Twig_Template
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

        // line 16
        echo "
";
        // line 17
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["icon"]) ? $context["icon"] : null), "html", null, true));
        echo "
";
    }

    public function getTemplateName()
    {
        return "modules/sitemap/templates/sitemap-feed-icon.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  46 => 17,  43 => 16,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme implementation to display RSS feed icon.*/
/*  **/
/*  * Available variables:*/
/*  * - url: The url of the feed.*/
/*  * - name: The name of the feed.*/
/*  * - type: The type of feed icon.*/
/*  * - icon: The default icon image.*/
/*  **/
/*  * @see template_preprocess()*/
/*  * @see template_preprocess_sitemap_feed_icon()*/
/*  *//* */
/* #}*/
/* */
/* {{ icon }}*/
/* */
