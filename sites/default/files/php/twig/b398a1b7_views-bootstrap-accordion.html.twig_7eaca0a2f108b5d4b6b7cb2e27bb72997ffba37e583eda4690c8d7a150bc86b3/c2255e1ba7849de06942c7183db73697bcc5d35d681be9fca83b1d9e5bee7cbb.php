<?php

/* modules/views_bootstrap/templates/views_bootstrap_accordion/views-bootstrap-accordion.html.twig */
class __TwigTemplate_14cb5e4030d6b050ef0f80730fd91ed47bf655d3c351e72b652eb92427d3e0d7 extends Twig_Template
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
        $__internal_29e8b6bfef65b845ddbee6dfe1f84adfef4f07f44e0b6df97316e9c48dbfa916 = $this->env->getExtension("native_profiler");
        $__internal_29e8b6bfef65b845ddbee6dfe1f84adfef4f07f44e0b6df97316e9c48dbfa916->enter($__internal_29e8b6bfef65b845ddbee6dfe1f84adfef4f07f44e0b6df97316e9c48dbfa916_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/views_bootstrap/templates/views_bootstrap_accordion/views-bootstrap-accordion.html.twig"));

        $tags = array("for" => 3);
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

        // line 1
        echo "<!-- @TODO: Make ID unique -->
<div id=\"views-bootstrap-accordion\" ";
        // line 2
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
        echo ">
  ";
        // line 3
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable((isset($context["rows"]) ? $context["rows"] : null));
        foreach ($context['_seq'] as $context["key"] => $context["row"]) {
            // line 4
            echo "<div class=\"panel panel-default\">
      <div class=\"panel-heading\">
        <h4 class=\"panel-title\">
          <a class=\"accordion-toggle\"
             data-toggle=\"collapse\"
             data-parent=\"#views-bootstrap-accordion\"
             href=\"#collapse-";
            // line 10
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $context["key"], "html", null, true));
            echo "\">
            ";
            // line 11
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["row"], "title", array()), "html", null, true));
            echo "
          </a>
        </h4>
      </div>

      <div id=\"collapse-";
            // line 16
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $context["key"], "html", null, true));
            echo "\" class=\"panel-collapse collapse\">
        <div class=\"panel-body\">
          ";
            // line 18
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["row"], "content", array()), "html", null, true));
            echo "
        </div>
      </div>
    </div>";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['key'], $context['row'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 23
        echo "</div>
";
        
        $__internal_29e8b6bfef65b845ddbee6dfe1f84adfef4f07f44e0b6df97316e9c48dbfa916->leave($__internal_29e8b6bfef65b845ddbee6dfe1f84adfef4f07f44e0b6df97316e9c48dbfa916_prof);

    }

    public function getTemplateName()
    {
        return "modules/views_bootstrap/templates/views_bootstrap_accordion/views-bootstrap-accordion.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  92 => 23,  82 => 18,  77 => 16,  69 => 11,  65 => 10,  57 => 4,  53 => 3,  49 => 2,  46 => 1,);
    }
}
/* <!-- @TODO: Make ID unique -->*/
/* <div id="views-bootstrap-accordion" {{ attributes.addClass(classes) }}>*/
/*   {% for key, row in rows -%}*/
/*     <div class="panel panel-default">*/
/*       <div class="panel-heading">*/
/*         <h4 class="panel-title">*/
/*           <a class="accordion-toggle"*/
/*              data-toggle="collapse"*/
/*              data-parent="#views-bootstrap-accordion"*/
/*              href="#collapse-{{key}}">*/
/*             {{row.title}}*/
/*           </a>*/
/*         </h4>*/
/*       </div>*/
/* */
/*       <div id="collapse-{{key}}" class="panel-collapse collapse">*/
/*         <div class="panel-body">*/
/*           {{row.content}}*/
/*         </div>*/
/*       </div>*/
/*     </div>*/
/*   {%- endfor %}*/
/* </div>*/
/* */
