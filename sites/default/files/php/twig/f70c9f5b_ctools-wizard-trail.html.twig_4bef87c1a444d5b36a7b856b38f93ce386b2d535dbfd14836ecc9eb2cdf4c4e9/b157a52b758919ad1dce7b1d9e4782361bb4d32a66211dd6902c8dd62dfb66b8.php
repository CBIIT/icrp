<?php

/* modules/ctools/templates/ctools-wizard-trail.html.twig */
class __TwigTemplate_d09d76923f9aa2b3ce840c6d0deab6ea2d47cc8f1681b556f8e5ead7d81d9600 extends Twig_Template
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
        $tags = array("if" => 1, "for" => 3);
        $filters = array("last" => 9);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if', 'for'),
                array('last'),
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
        if ((isset($context["trail"]) ? $context["trail"] : null)) {
            // line 2
            echo "<div class=\"wizard-trail\">
    ";
            // line 3
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["trail"]) ? $context["trail"] : null));
            foreach ($context['_seq'] as $context["key"] => $context["value"]) {
                // line 4
                echo "        ";
                if (($context["key"] === (isset($context["step"]) ? $context["step"] : null))) {
                    // line 5
                    echo "            <strong>";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $context["value"], "html", null, true));
                    echo "</strong>
        ";
                } else {
                    // line 7
                    echo "            ";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $context["value"], "html", null, true));
                    echo "
        ";
                }
                // line 9
                echo "        ";
                if ( !($context["value"] === twig_last($this->env, (isset($context["trail"]) ? $context["trail"] : null)))) {
                    // line 10
                    echo "            ";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["divider"]) ? $context["divider"] : null), "html", null, true));
                    echo "
        ";
                }
                // line 12
                echo "    ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['key'], $context['value'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 13
            echo "</div>
";
        }
    }

    public function getTemplateName()
    {
        return "modules/ctools/templates/ctools-wizard-trail.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  82 => 13,  76 => 12,  70 => 10,  67 => 9,  61 => 7,  55 => 5,  52 => 4,  48 => 3,  45 => 2,  43 => 1,);
    }
}
/* {% if trail %}*/
/* <div class="wizard-trail">*/
/*     {% for key, value in trail %}*/
/*         {% if key is same as(step) %}*/
/*             <strong>{{ value }}</strong>*/
/*         {% else %}*/
/*             {{ value }}*/
/*         {% endif %}*/
/*         {% if value is not same as(trail|last) %}*/
/*             {{ divider }}*/
/*         {% endif %}*/
/*     {% endfor %}*/
/* </div>*/
/* {% endif %}*/
/* */
