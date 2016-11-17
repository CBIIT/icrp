<?php

/* themes/bootstrap/templates/system/region.html.twig */
class __TwigTemplate_b0f11d1f335a1035c19efb15fecfcd60e41ef8f6d4d62aef140afd42e63fcb46 extends Twig_Template
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
        $__internal_66b9fc7bc370e3f9c7e569c4274d18086115bb6d1be1429efb37ad263cf728df = $this->env->getExtension("native_profiler");
        $__internal_66b9fc7bc370e3f9c7e569c4274d18086115bb6d1be1429efb37ad263cf728df->enter($__internal_66b9fc7bc370e3f9c7e569c4274d18086115bb6d1be1429efb37ad263cf728df_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/system/region.html.twig"));

        $tags = array("set" => 18, "if" => 23);
        $filters = array("clean_class" => 20);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'if'),
                array('clean_class'),
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

        // line 18
        $context["classes"] = array(0 => "region", 1 => ("region-" . \Drupal\Component\Utility\Html::getClass(        // line 20
(isset($context["region"]) ? $context["region"] : null))));
        // line 23
        if ((isset($context["content"]) ? $context["content"] : null)) {
            // line 24
            echo "  <div";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
            echo ">
    ";
            // line 25
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
            echo "
  </div>
";
        }
        
        $__internal_66b9fc7bc370e3f9c7e569c4274d18086115bb6d1be1429efb37ad263cf728df->leave($__internal_66b9fc7bc370e3f9c7e569c4274d18086115bb6d1be1429efb37ad263cf728df_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/system/region.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  56 => 25,  51 => 24,  49 => 23,  47 => 20,  46 => 18,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override to display a region.*/
/*  **/
/*  * Available variables:*/
/*  * - content: The content for this region, typically blocks.*/
/*  * - attributes: HTML attributes for the region div.*/
/*  * - region: The name of the region variable as defined in the theme's*/
/*  *   .info.yml file.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_region()*/
/*  *//* */
/* #}*/
/* {%*/
/*   set classes = [*/
/*     'region',*/
/*     'region-' ~ region|clean_class,*/
/*   ]*/
/* %}*/
/* {% if content %}*/
/*   <div{{ attributes.addClass(classes) }}>*/
/*     {{ content }}*/
/*   </div>*/
/* {% endif %}*/
/* */
