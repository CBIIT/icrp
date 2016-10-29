<?php

/* core/modules/system/templates/time.html.twig */
class __TwigTemplate_a55186e313a3279264e22ae26d413e2da4ef1772da6e685358d3a5c204a9c68e extends Twig_Template
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

        // line 22
        echo "<time";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["attributes"]) ? $context["attributes"] : null), "html", null, true));
        echo ">";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["text"]) ? $context["text"] : null), "html", null, true));
        echo "</time>
";
    }

    public function getTemplateName()
    {
        return "core/modules/system/templates/time.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  43 => 22,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for a date / time element.*/
/*  **/
/*  * Available variables*/
/*  * - timestamp: (optional) A UNIX timestamp for the datetime attribute. If the*/
/*  *   datetime cannot be represented as a UNIX timestamp, use a valid datetime*/
/*  *   attribute value in attributes.datetime.*/
/*  * - text: (optional) The content to display within the <time> element.*/
/*  *   Defaults to a human-readable representation of the timestamp value or the*/
/*  *   datetime attribute value using format_date().*/
/*  * - attributes: (optional) HTML attributes to apply to the <time> element.*/
/*  *   A datetime attribute in 'attributes' overrides the 'timestamp'. To*/
/*  *   create a valid datetime attribute value from a UNIX timestamp, use*/
/*  *   format_date() with one of the predefined 'html_*' formats.*/
/*  **/
/*  * @see template_preprocess_time()*/
/*  * @see http://www.w3.org/TR/html5-author/the-time-element.html#attr-time-datetime*/
/*  *//* */
/* #}*/
/* <time{{ attributes }}>{{ text }}</time>*/
/* */
