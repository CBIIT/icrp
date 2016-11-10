<?php

/* modules/sitemap/templates/sitemap.html.twig */
class __TwigTemplate_2662160a864258c53a384e77b8f5f66bf9b327bc329a8c60776aad952f8e2165 extends Twig_Template
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
        $__internal_9298b66734c9d0e7bf00a3ee5da9b2175dc05b817ed5cad6dc061b45751bc817 = $this->env->getExtension("native_profiler");
        $__internal_9298b66734c9d0e7bf00a3ee5da9b2175dc05b817ed5cad6dc061b45751bc817->enter($__internal_9298b66734c9d0e7bf00a3ee5da9b2175dc05b817ed5cad6dc061b45751bc817_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/sitemap/templates/sitemap.html.twig"));

        $tags = array("if" => 27, "for" => 34);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if', 'for'),
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

        // line 25
        echo "
<div class=\"sitemap\">
  ";
        // line 27
        if ((isset($context["message"]) ? $context["message"] : null)) {
            // line 28
            echo "    <div class=\"sitemap-message\">
      ";
            // line 29
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["message"]) ? $context["message"] : null), "html", null, true));
            echo "
    </div>
  ";
        }
        // line 32
        echo "
  ";
        // line 33
        if ((isset($context["sitemap_items"]) ? $context["sitemap_items"] : null)) {
            // line 34
            echo "    ";
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["sitemap_items"]) ? $context["sitemap_items"] : null));
            foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                // line 35
                echo "      <div";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["item"], "attributes", array()), "addClass", array(0 => "sitemap-box"), "method"), "html", null, true));
                echo ">
        ";
                // line 36
                if ($this->getAttribute($this->getAttribute($context["item"], "options", array()), "show_titles", array())) {
                    // line 37
                    echo "          <h2>";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "title", array()), "html", null, true));
                    echo "</h2>
        ";
                }
                // line 39
                echo "        <div class=\"content\">
          ";
                // line 40
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "content", array()), "html", null, true));
                echo "
        </div>
      </div>
    ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 44
            echo "  ";
        }
        // line 45
        echo "
  ";
        // line 46
        if ((isset($context["additional"]) ? $context["additional"] : null)) {
            // line 47
            echo "    <div class=\"sitemap-additional\">
      ";
            // line 48
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["additional"]) ? $context["additional"] : null), "html", null, true));
            echo "
    </div>
  ";
        }
        // line 51
        echo "</div>
";
        
        $__internal_9298b66734c9d0e7bf00a3ee5da9b2175dc05b817ed5cad6dc061b45751bc817->leave($__internal_9298b66734c9d0e7bf00a3ee5da9b2175dc05b817ed5cad6dc061b45751bc817_prof);

    }

    public function getTemplateName()
    {
        return "modules/sitemap/templates/sitemap.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  114 => 51,  108 => 48,  105 => 47,  103 => 46,  100 => 45,  97 => 44,  87 => 40,  84 => 39,  78 => 37,  76 => 36,  71 => 35,  66 => 34,  64 => 33,  61 => 32,  55 => 29,  52 => 28,  50 => 27,  46 => 25,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme implementation to display the sitemap.*/
/*  **/
/*  * Available variables:*/
/*  * - message: A configurable introductory message.*/
/*  * - sitemap_items: A keyed array of sitemap "boxes".*/
/*  *   The keys correspond to the available types of sitemap content, including:*/
/*  *   - front*/
/*  *   - books*/
/*  *   - individual menus*/
/*  *   - individual vocabularies*/
/*  *   Each items contains the following variables:*/
/*  *   - title: The subject of the box.*/
/*  *   - content: The content of the box.*/
/*  *   - attributes:  Optional attributes for the box.*/
/*  *   - options:  Options are set by sitemap.helper service.*/
/*  * - additional:*/
/*  **/
/*  * @see template_preprocess()*/
/*  * @see template_preprocess_sitemap()*/
/*  *//* */
/* #}*/
/* */
/* <div class="sitemap">*/
/*   {% if message %}*/
/*     <div class="sitemap-message">*/
/*       {{ message }}*/
/*     </div>*/
/*   {% endif %}*/
/* */
/*   {% if sitemap_items %}*/
/*     {% for item in sitemap_items %}*/
/*       <div{{ item.attributes.addClass('sitemap-box') }}>*/
/*         {% if item.options.show_titles %}*/
/*           <h2>{{ item.title }}</h2>*/
/*         {% endif %}*/
/*         <div class="content">*/
/*           {{ item.content }}*/
/*         </div>*/
/*       </div>*/
/*     {% endfor %}*/
/*   {% endif %}*/
/* */
/*   {% if additional %}*/
/*     <div class="sitemap-additional">*/
/*       {{ additional }}*/
/*     </div>*/
/*   {% endif %}*/
/* </div>*/
/* */
