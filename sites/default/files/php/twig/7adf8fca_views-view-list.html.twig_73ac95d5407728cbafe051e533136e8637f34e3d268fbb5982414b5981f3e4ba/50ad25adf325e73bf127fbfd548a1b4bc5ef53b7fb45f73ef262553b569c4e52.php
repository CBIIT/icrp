<?php

/* core/themes/classy/templates/views/views-view-list.html.twig */
class __TwigTemplate_1243f72871226be77d2accdf35bc11030f6a718315a2f67993194c41deb63d13 extends Twig_Template
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
        $tags = array("if" => 19, "for" => 28);
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

        // line 19
        if ((isset($context["attributes"]) ? $context["attributes"] : null)) {
            // line 20
            echo "<div";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["attributes"]) ? $context["attributes"] : null), "html", null, true));
            echo ">
";
        }
        // line 22
        echo "  ";
        if ((isset($context["title"]) ? $context["title"] : null)) {
            // line 23
            echo "    <h3>";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title"]) ? $context["title"] : null), "html", null, true));
            echo "</h3>
  ";
        }
        // line 25
        echo "
  <";
        // line 26
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["list"]) ? $context["list"] : null), "type", array()), "html", null, true));
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["list"]) ? $context["list"] : null), "attributes", array()), "html", null, true));
        echo ">

    ";
        // line 28
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable((isset($context["rows"]) ? $context["rows"] : null));
        foreach ($context['_seq'] as $context["_key"] => $context["row"]) {
            // line 29
            echo "      <li";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["row"], "attributes", array()), "html", null, true));
            echo ">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["row"], "content", array()), "html", null, true));
            echo "</li>
    ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['row'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 31
        echo "
  </";
        // line 32
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["list"]) ? $context["list"] : null), "type", array()), "html", null, true));
        echo ">

";
        // line 34
        if ((isset($context["attributes"]) ? $context["attributes"] : null)) {
            // line 35
            echo "</div>
";
        }
    }

    public function getTemplateName()
    {
        return "core/themes/classy/templates/views/views-view-list.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  94 => 35,  92 => 34,  87 => 32,  84 => 31,  73 => 29,  69 => 28,  63 => 26,  60 => 25,  54 => 23,  51 => 22,  45 => 20,  43 => 19,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override for a view template to display a list of rows.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes for the container.*/
/*  * - rows: A list of rows for this list.*/
/*  *   - attributes: The row's HTML attributes.*/
/*  *   - content: The row's contents.*/
/*  * - title: The title of this group of rows. May be empty.*/
/*  * - list: @todo.*/
/*  *   - type: Starting tag will be either a ul or ol.*/
/*  *   - attributes: HTML attributes for the list element.*/
/*  **/
/*  * @see template_preprocess_views_view_list()*/
/*  *//* */
/* #}*/
/* {% if attributes -%}*/
/*   <div{{ attributes }}>*/
/* {% endif %}*/
/*   {% if title %}*/
/*     <h3>{{ title }}</h3>*/
/*   {% endif %}*/
/* */
/*   <{{ list.type }}{{ list.attributes }}>*/
/* */
/*     {% for row in rows %}*/
/*       <li{{ row.attributes }}>{{ row.content }}</li>*/
/*     {% endfor %}*/
/* */
/*   </{{ list.type }}>*/
/* */
/* {% if attributes -%}*/
/*   </div>*/
/* {% endif %}*/
/* */
