<?php

/* modules/bootstrap_layouts/templates/bricks/bootstrap-6-6-bricks/bootstrap-6-6-bricks.html.twig */
class __TwigTemplate_5c556b0ef5b827c58509b4741c55d15b6603beed956220fa54a3af704737a1b7 extends Twig_Template
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
        $__internal_3231903257ebb514dea368f2bb604977fb991906970b565ee4434bb92900d7d5 = $this->env->getExtension("native_profiler");
        $__internal_3231903257ebb514dea368f2bb604977fb991906970b565ee4434bb92900d7d5->enter($__internal_3231903257ebb514dea368f2bb604977fb991906970b565ee4434bb92900d7d5_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/bootstrap_layouts/templates/bricks/bootstrap-6-6-bricks/bootstrap-6-6-bricks.html.twig"));

        $tags = array("if" => 2);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if'),
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
        echo "<div class=\"row\">
  ";
        // line 2
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "top", array())) {
            // line 3
            echo "  <div class=\"col-sm-12\">
    ";
            // line 4
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "top", array()), "html", null, true));
            echo "
  </div>
  ";
        }
        // line 7
        echo "
  ";
        // line 8
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "upper_left", array())) {
            // line 9
            echo "  <div class=\"col-sm-6\">
    ";
            // line 10
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "upper_left", array()), "html", null, true));
            echo "
  </div>
  ";
        }
        // line 13
        echo "
  ";
        // line 14
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "upper_right", array())) {
            // line 15
            echo "  <div class=\"col-sm-6\">
    ";
            // line 16
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "upper_right", array()), "html", null, true));
            echo "
  </div>
  ";
        }
        // line 19
        echo "
  ";
        // line 20
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "middle", array())) {
            // line 21
            echo "  <div class=\"col-sm-12\">
    ";
            // line 22
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "middle", array()), "html", null, true));
            echo "
  </div>
  ";
        }
        // line 25
        echo "
  ";
        // line 26
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "lower_left", array())) {
            // line 27
            echo "  <div class=\"col-sm-6\">
    ";
            // line 28
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "lower_left", array()), "html", null, true));
            echo "
  </div>
  ";
        }
        // line 31
        echo "
  ";
        // line 32
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "lower_right", array())) {
            // line 33
            echo "  <div class=\"col-sm-6\">
    ";
            // line 34
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "lower_right", array()), "html", null, true));
            echo "
  </div>
  ";
        }
        // line 37
        echo "
  ";
        // line 38
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "bottom", array())) {
            // line 39
            echo "  <div class=\"col-sm-12\">
    ";
            // line 40
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "bottom", array()), "html", null, true));
            echo "
  </div>
  ";
        }
        // line 43
        echo "</div>
";
        
        $__internal_3231903257ebb514dea368f2bb604977fb991906970b565ee4434bb92900d7d5->leave($__internal_3231903257ebb514dea368f2bb604977fb991906970b565ee4434bb92900d7d5_prof);

    }

    public function getTemplateName()
    {
        return "modules/bootstrap_layouts/templates/bricks/bootstrap-6-6-bricks/bootstrap-6-6-bricks.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  144 => 43,  138 => 40,  135 => 39,  133 => 38,  130 => 37,  124 => 34,  121 => 33,  119 => 32,  116 => 31,  110 => 28,  107 => 27,  105 => 26,  102 => 25,  96 => 22,  93 => 21,  91 => 20,  88 => 19,  82 => 16,  79 => 15,  77 => 14,  74 => 13,  68 => 10,  65 => 9,  63 => 8,  60 => 7,  54 => 4,  51 => 3,  49 => 2,  46 => 1,);
    }
}
/* <div class="row">*/
/*   {% if content.top %}*/
/*   <div class="col-sm-12">*/
/*     {{ content.top }}*/
/*   </div>*/
/*   {% endif %}*/
/* */
/*   {% if content.upper_left %}*/
/*   <div class="col-sm-6">*/
/*     {{ content.upper_left }}*/
/*   </div>*/
/*   {% endif %}*/
/* */
/*   {% if content.upper_right %}*/
/*   <div class="col-sm-6">*/
/*     {{ content.upper_right }}*/
/*   </div>*/
/*   {% endif %}*/
/* */
/*   {% if content.middle %}*/
/*   <div class="col-sm-12">*/
/*     {{ content.middle }}*/
/*   </div>*/
/*   {% endif %}*/
/* */
/*   {% if content.lower_left %}*/
/*   <div class="col-sm-6">*/
/*     {{ content.lower_left }}*/
/*   </div>*/
/*   {% endif %}*/
/* */
/*   {% if content.lower_right %}*/
/*   <div class="col-sm-6">*/
/*     {{ content.lower_right }}*/
/*   </div>*/
/*   {% endif %}*/
/* */
/*   {% if content.bottom %}*/
/*   <div class="col-sm-12">*/
/*     {{ content.bottom }}*/
/*   </div>*/
/*   {% endif %}*/
/* </div>*/
/* */
