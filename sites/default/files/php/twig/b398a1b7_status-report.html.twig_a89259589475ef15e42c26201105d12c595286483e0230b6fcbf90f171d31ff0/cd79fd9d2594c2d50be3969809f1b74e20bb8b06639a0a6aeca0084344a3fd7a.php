<?php

/* core/themes/stable/templates/admin/status-report.html.twig */
class __TwigTemplate_82d2a56c3cd24784158d7ab3b8463132af3f5446330482d127a907270c238d18 extends Twig_Template
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
        $__internal_44484f2b30bbfcf6811d825610eaf8ff311863f146a3101a0aa7668911a912d4 = $this->env->getExtension("native_profiler");
        $__internal_44484f2b30bbfcf6811d825610eaf8ff311863f146a3101a0aa7668911a912d4->enter($__internal_44484f2b30bbfcf6811d825610eaf8ff311863f146a3101a0aa7668911a912d4_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/themes/stable/templates/admin/status-report.html.twig"));

        $tags = array("for" => 20, "if" => 22);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('for', 'if'),
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

        // line 18
        echo "<table class=\"system-status-report\">
  <tbody>
  ";
        // line 20
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable((isset($context["requirements"]) ? $context["requirements"] : null));
        foreach ($context['_seq'] as $context["_key"] => $context["requirement"]) {
            // line 21
            echo "    <tr class=\"system-status-report__entry system-status-report__entry--";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["requirement"], "severity_status", array()), "html", null, true));
            echo " color-";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["requirement"], "severity_status", array()), "html", null, true));
            echo "\">
      ";
            // line 22
            if (twig_in_filter($this->getAttribute($context["requirement"], "severity_status", array()), array(0 => "warning", 1 => "error"))) {
                // line 23
                echo "        <th class=\"system-status-report__status-title system-status-report__status-icon system-status-report__status-icon--";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["requirement"], "severity_status", array()), "html", null, true));
                echo "\">
          <span class=\"visually-hidden\">";
                // line 24
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["requirement"], "severity_title", array()), "html", null, true));
                echo "</span>
      ";
            } else {
                // line 26
                echo "        <th class=\"system-status-report__status-title\">
      ";
            }
            // line 28
            echo "        ";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["requirement"], "title", array()), "html", null, true));
            echo "
      </th>
      <td>
        ";
            // line 31
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["requirement"], "value", array()), "html", null, true));
            echo "
        ";
            // line 32
            if ($this->getAttribute($context["requirement"], "description", array())) {
                // line 33
                echo "          <div class=\"description\">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["requirement"], "description", array()), "html", null, true));
                echo "</div>
        ";
            }
            // line 35
            echo "      </td>
    </tr>
  ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['requirement'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 38
        echo "  </tbody>
</table>
";
        
        $__internal_44484f2b30bbfcf6811d825610eaf8ff311863f146a3101a0aa7668911a912d4->leave($__internal_44484f2b30bbfcf6811d825610eaf8ff311863f146a3101a0aa7668911a912d4_prof);

    }

    public function getTemplateName()
    {
        return "core/themes/stable/templates/admin/status-report.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  104 => 38,  96 => 35,  90 => 33,  88 => 32,  84 => 31,  77 => 28,  73 => 26,  68 => 24,  63 => 23,  61 => 22,  54 => 21,  50 => 20,  46 => 18,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override for the status report.*/
/*  **/
/*  * Available variables:*/
/*  * - requirements: Contains multiple requirement instances.*/
/*  *   Each requirement contains:*/
/*  *   - title: The title of the requirement.*/
/*  *   - value: (optional) The requirement's status.*/
/*  *   - description: (optional) The requirement's description.*/
/*  *   - severity_title: The title of the severity.*/
/*  *   - severity_status: Indicates the severity status.*/
/*  **/
/*  * @see template_preprocess_status_report()*/
/*  *//* */
/* #}*/
/* <table class="system-status-report">*/
/*   <tbody>*/
/*   {% for requirement in requirements %}*/
/*     <tr class="system-status-report__entry system-status-report__entry--{{ requirement.severity_status }} color-{{ requirement.severity_status }}">*/
/*       {% if requirement.severity_status in ['warning', 'error'] %}*/
/*         <th class="system-status-report__status-title system-status-report__status-icon system-status-report__status-icon--{{ requirement.severity_status }}">*/
/*           <span class="visually-hidden">{{ requirement.severity_title }}</span>*/
/*       {% else %}*/
/*         <th class="system-status-report__status-title">*/
/*       {% endif %}*/
/*         {{ requirement.title }}*/
/*       </th>*/
/*       <td>*/
/*         {{ requirement.value }}*/
/*         {% if requirement.description %}*/
/*           <div class="description">{{ requirement.description }}</div>*/
/*         {% endif %}*/
/*       </td>*/
/*     </tr>*/
/*   {% endfor %}*/
/*   </tbody>*/
/* </table>*/
/* */
