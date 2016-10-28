<?php

/* themes/bootstrap/templates/field/field-multiple-value-form.html.twig */
class __TwigTemplate_3a70ac867f2a67f1d60c8fb4763d83f872646c15b50259c51c8c24042f50240e extends Twig_Template
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
        $tags = array("if" => 22, "for" => 33);
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

        // line 22
        if ((isset($context["multiple"]) ? $context["multiple"] : null)) {
            // line 23
            echo "  <div class=\"form-item\">
    ";
            // line 24
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["table"]) ? $context["table"] : null), "html", null, true));
            echo "
    ";
            // line 25
            if ($this->getAttribute((isset($context["description"]) ? $context["description"] : null), "content", array())) {
                // line 26
                echo "      <div class=\"description help-block\">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["description"]) ? $context["description"] : null), "content", array()), "html", null, true));
                echo "</div>
    ";
            }
            // line 28
            echo "    ";
            if ((isset($context["button"]) ? $context["button"] : null)) {
                // line 29
                echo "      <div class=\"clearfix\">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["button"]) ? $context["button"] : null), "html", null, true));
                echo "</div>
    ";
            }
            // line 31
            echo "  </div>
";
        } else {
            // line 33
            echo "  ";
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["elements"]) ? $context["elements"] : null));
            foreach ($context['_seq'] as $context["_key"] => $context["element"]) {
                // line 34
                echo "    ";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $context["element"], "html", null, true));
                echo "
  ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['element'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
        }
    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/field/field-multiple-value-form.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  78 => 34,  73 => 33,  69 => 31,  63 => 29,  60 => 28,  54 => 26,  52 => 25,  48 => 24,  45 => 23,  43 => 22,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for an individual form element.*/
/*  **/
/*  * Available variables for all fields:*/
/*  * - multiple: Whether there are multiple instances of the field.*/
/*  **/
/*  * Available variables for single cardinality fields:*/
/*  * - elements: Form elements to be rendered.*/
/*  **/
/*  * Available variables when there are multiple fields.*/
/*  * - table: Table of field items.*/
/*  * - description: Description text for the form element.*/
/*  * - button: "Add another item" button.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_field_multiple_value_form()*/
/*  *//* */
/* #}*/
/* {% if multiple %}*/
/*   <div class="form-item">*/
/*     {{ table }}*/
/*     {% if description.content %}*/
/*       <div class="description help-block">{{ description.content }}</div>*/
/*     {% endif %}*/
/*     {% if button %}*/
/*       <div class="clearfix">{{ button }}</div>*/
/*     {% endif %}*/
/*   </div>*/
/* {% else %}*/
/*   {% for element in elements %}*/
/*     {{ element }}*/
/*   {% endfor %}*/
/* {% endif %}*/
/* */
