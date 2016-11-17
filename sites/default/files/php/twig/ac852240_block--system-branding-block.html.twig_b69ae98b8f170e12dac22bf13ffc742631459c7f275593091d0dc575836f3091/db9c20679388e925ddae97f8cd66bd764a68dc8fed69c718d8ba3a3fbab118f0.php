<?php

/* themes/bootstrap/templates/block/block--system-branding-block.html.twig */
class __TwigTemplate_6dba5e09cda9b3e7df2fa0421c320dbf55035065000e14fe9e079b61b4a74689 extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        // line 1
        $this->parent = $this->loadTemplate("block--bare.html.twig", "themes/bootstrap/templates/block/block--system-branding-block.html.twig", 1);
        $this->blocks = array(
            'content' => array($this, 'block_content'),
        );
    }

    protected function doGetParent(array $context)
    {
        return "block--bare.html.twig";
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $__internal_c5b61579da1d25e3381f3e4c0bd7734e45bda4c187b5ccff02bcc5a6109f843a = $this->env->getExtension("native_profiler");
        $__internal_c5b61579da1d25e3381f3e4c0bd7734e45bda4c187b5ccff02bcc5a6109f843a->enter($__internal_c5b61579da1d25e3381f3e4c0bd7734e45bda4c187b5ccff02bcc5a6109f843a_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/block/block--system-branding-block.html.twig"));

        $tags = array("if" => 19);
        $filters = array("t" => 20);
        $functions = array("path" => 20);

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if'),
                array('t'),
                array('path')
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

        $this->parent->display($context, array_merge($this->blocks, $blocks));
        
        $__internal_c5b61579da1d25e3381f3e4c0bd7734e45bda4c187b5ccff02bcc5a6109f843a->leave($__internal_c5b61579da1d25e3381f3e4c0bd7734e45bda4c187b5ccff02bcc5a6109f843a_prof);

    }

    // line 18
    public function block_content($context, array $blocks = array())
    {
        $__internal_a77e7bb685bb789a0258a7b425e8859cd9bd750d2e36936ffa4944ced21c4605 = $this->env->getExtension("native_profiler");
        $__internal_a77e7bb685bb789a0258a7b425e8859cd9bd750d2e36936ffa4944ced21c4605->enter($__internal_a77e7bb685bb789a0258a7b425e8859cd9bd750d2e36936ffa4944ced21c4605_prof = new Twig_Profiler_Profile($this->getTemplateName(), "block", "content"));

        // line 19
        echo "  ";
        if ((isset($context["site_logo"]) ? $context["site_logo"] : null)) {
            // line 20
            echo "    <a class=\"logo navbar-btn pull-left\" href=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($this->env->getExtension('drupal_core')->getPath("<front>")));
            echo "\" title=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Home")));
            echo "\" rel=\"home\">
      <img src=\"";
            // line 21
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["site_logo"]) ? $context["site_logo"] : null), "html", null, true));
            echo "\" alt=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Home")));
            echo "\" />
    </a>
  ";
        }
        // line 24
        echo "  ";
        if ((isset($context["site_name"]) ? $context["site_name"] : null)) {
            // line 25
            echo "    <a class=\"name navbar-brand\" href=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($this->env->getExtension('drupal_core')->getPath("<front>")));
            echo "\" title=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Home")));
            echo "\" rel=\"home\">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["site_name"]) ? $context["site_name"] : null), "html", null, true));
            echo "</a>
  ";
        }
        // line 27
        echo "  ";
        if ((isset($context["site_slogan"]) ? $context["site_slogan"] : null)) {
            // line 28
            echo "    <p class=\"navbar-text\">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["site_slogan"]) ? $context["site_slogan"] : null), "html", null, true));
            echo "</p>
  ";
        }
        
        $__internal_a77e7bb685bb789a0258a7b425e8859cd9bd750d2e36936ffa4944ced21c4605->leave($__internal_a77e7bb685bb789a0258a7b425e8859cd9bd750d2e36936ffa4944ced21c4605_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/block/block--system-branding-block.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  98 => 28,  95 => 27,  85 => 25,  82 => 24,  74 => 21,  67 => 20,  64 => 19,  58 => 18,  11 => 1,);
    }
}
/* {% extends "block--bare.html.twig" %}*/
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for a branding block.*/
/*  **/
/*  * Each branding element variable (logo, name, slogan) is only available if*/
/*  * enabled in the block configuration.*/
/*  **/
/*  * Available variables:*/
/*  * - site_logo: Logo for site as defined in Appearance or theme settings.*/
/*  * - site_name: Name for site as defined in Site information settings.*/
/*  * - site_slogan: Slogan for site as defined in Site information settings.*/
/*  **/
/*  * @ingroup templates*/
/*  *//* */
/* #}*/
/* {% block content %}*/
/*   {% if site_logo %}*/
/*     <a class="logo navbar-btn pull-left" href="{{ path('<front>') }}" title="{{ 'Home'|t }}" rel="home">*/
/*       <img src="{{ site_logo }}" alt="{{ 'Home'|t }}" />*/
/*     </a>*/
/*   {% endif %}*/
/*   {% if site_name %}*/
/*     <a class="name navbar-brand" href="{{ path('<front>') }}" title="{{ 'Home'|t }}" rel="home">{{ site_name }}</a>*/
/*   {% endif %}*/
/*   {% if site_slogan %}*/
/*     <p class="navbar-text">{{ site_slogan }}</p>*/
/*   {% endif %}*/
/* {% endblock %}*/
/* */
