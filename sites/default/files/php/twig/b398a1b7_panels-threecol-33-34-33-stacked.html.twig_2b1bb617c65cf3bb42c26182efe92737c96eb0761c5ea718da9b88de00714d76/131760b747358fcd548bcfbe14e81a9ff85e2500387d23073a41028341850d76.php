<?php

/* modules/panels/layouts/threecol_33_34_33_stacked/panels-threecol-33-34-33-stacked.html.twig */
class __TwigTemplate_00f5b67cf34205b4e16de33ef084e0e3aabbc57b6d4ed65a7fef761987256def extends Twig_Template
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
        $__internal_51caa3e413dc21e517371b9d5fef79978635b05525b276f9e7958249b9ad75bc = $this->env->getExtension("native_profiler");
        $__internal_51caa3e413dc21e517371b9d5fef79978635b05525b276f9e7958249b9ad75bc->enter($__internal_51caa3e413dc21e517371b9d5fef79978635b05525b276f9e7958249b9ad75bc_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/panels/layouts/threecol_33_34_33_stacked/panels-threecol-33-34-33-stacked.html.twig"));

        $tags = array("if" => 20);
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

        // line 20
        echo "<div class=\"panel-3col-33-stacked\" ";
        if ((isset($context["css_id"]) ? $context["css_id"] : null)) {
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["css_id"]) ? $context["css_id"] : null), "html", null, true));
        }
        echo ">
  ";
        // line 21
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "top", array())) {
            // line 22
            echo "    <div class=\"panel-panel panel-full-width\">
      ";
            // line 23
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "top", array()), "html", null, true));
            echo "
    </div>
  ";
        }
        // line 26
        echo "
  <div class=\"panel-panel\">
    ";
        // line 28
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "left", array()), "html", null, true));
        echo "
  </div>

  <div class=\"panel-panel\">
    ";
        // line 32
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "middle", array()), "html", null, true));
        echo "
  </div>

  <div class=\"panel-panel\">
    ";
        // line 36
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "right", array()), "html", null, true));
        echo "
  </div>

  ";
        // line 39
        if ($this->getAttribute((isset($context["content"]) ? $context["content"] : null), "bottom", array())) {
            // line 40
            echo "    <div class=\"panel-panel panel-full-width\">
      ";
            // line 41
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["content"]) ? $context["content"] : null), "bottom", array()), "html", null, true));
            echo "
    </div>
  ";
        }
        // line 44
        echo "</div>
";
        
        $__internal_51caa3e413dc21e517371b9d5fef79978635b05525b276f9e7958249b9ad75bc->leave($__internal_51caa3e413dc21e517371b9d5fef79978635b05525b276f9e7958249b9ad75bc_prof);

    }

    public function getTemplateName()
    {
        return "modules/panels/layouts/threecol_33_34_33_stacked/panels-threecol-33-34-33-stacked.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  99 => 44,  93 => 41,  90 => 40,  88 => 39,  82 => 36,  75 => 32,  68 => 28,  64 => 26,  58 => 23,  55 => 22,  53 => 21,  46 => 20,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Template for a 3 column panel layout.*/
/*  **/
/*  * This template provides a three column 33%-34%-33% panel display layout, with*/
/*  * additional areas for the top and the bottom.*/
/*  **/
/*  * Variables:*/
/*  * - $id: An optional CSS id to use for the layout.*/
/*  * - $content: An array of content, each item in the array is keyed to one*/
/*  *   panel of the layout. This layout supports the following sections:*/
/*  *   - content.top: Content in the top row.*/
/*  *   - content.left: Content in the left column.*/
/*  *   - content.middle: Content in the middle column.*/
/*  *   - content.right: Content in the right column.*/
/*  *   - content.bottom: Content in the bottom row.*/
/*  *//* */
/* #}*/
/* <div class="panel-3col-33-stacked" {% if css_id %}{{ css_id }}{% endif %}>*/
/*   {% if content.top %}*/
/*     <div class="panel-panel panel-full-width">*/
/*       {{ content.top }}*/
/*     </div>*/
/*   {% endif %}*/
/* */
/*   <div class="panel-panel">*/
/*     {{ content.left }}*/
/*   </div>*/
/* */
/*   <div class="panel-panel">*/
/*     {{ content.middle }}*/
/*   </div>*/
/* */
/*   <div class="panel-panel">*/
/*     {{ content.right }}*/
/*   </div>*/
/* */
/*   {% if content.bottom %}*/
/*     <div class="panel-panel panel-full-width">*/
/*       {{ content.bottom }}*/
/*     </div>*/
/*   {% endif %}*/
/* </div>*/
/* */
