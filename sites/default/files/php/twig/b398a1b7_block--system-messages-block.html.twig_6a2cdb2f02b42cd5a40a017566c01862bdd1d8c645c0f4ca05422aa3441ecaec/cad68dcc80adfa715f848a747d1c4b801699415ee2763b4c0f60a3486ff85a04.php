<?php

/* core/modules/system/templates/block--system-messages-block.html.twig */
class __TwigTemplate_169ae9ac561b66370d100a41770b25fae42dc84737fe145d13b6df8af4c0a4c9 extends Twig_Template
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
        $__internal_3ebb494af6eed9bd4dfef7dbef4b00e433f5e30a0d1e1ea7f7d4bfd7a8f1103d = $this->env->getExtension("native_profiler");
        $__internal_3ebb494af6eed9bd4dfef7dbef4b00e433f5e30a0d1e1ea7f7d4bfd7a8f1103d->enter($__internal_3ebb494af6eed9bd4dfef7dbef4b00e433f5e30a0d1e1ea7f7d4bfd7a8f1103d_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/system/templates/block--system-messages-block.html.twig"));

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
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
        echo "
";
        
        $__internal_3ebb494af6eed9bd4dfef7dbef4b00e433f5e30a0d1e1ea7f7d4bfd7a8f1103d->leave($__internal_3ebb494af6eed9bd4dfef7dbef4b00e433f5e30a0d1e1ea7f7d4bfd7a8f1103d_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/system/templates/block--system-messages-block.html.twig";
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
/*  * Default theme implementation for the messages block.*/
/*  **/
/*  * Removes wrapper elements from block so that empty block does not appear when*/
/*  * there are no messages.*/
/*  **/
/*  * Available variables:*/
/*  * - content: The content of this block.*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* {{ content }}*/
/* */
