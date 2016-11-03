<?php

/* core/themes/stable/templates/admin/update-project-status.html.twig */
class __TwigTemplate_0b7bd05ee8956710ff64e308f15de22819def11586d8eb1834d83bead38e36a0 extends Twig_Template
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
        $__internal_7dc25ae5a92cce2eb222230a9d779dde202e4b56676c6fe4ada0f2987bf66601 = $this->env->getExtension("native_profiler");
        $__internal_7dc25ae5a92cce2eb222230a9d779dde202e4b56676c6fe4ada0f2987bf66601->enter($__internal_7dc25ae5a92cce2eb222230a9d779dde202e4b56676c6fe4ada0f2987bf66601_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/themes/stable/templates/admin/update-project-status.html.twig"));

        $tags = array("set" => 29, "if" => 38, "for" => 61, "trans" => 88);
        $filters = array("join" => 83, "t" => 85, "placeholder" => 89);
        $functions = array("constant" => 30);

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'if', 'for', 'trans'),
                array('join', 't', 'placeholder'),
                array('constant')
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

        // line 29
        $context["status_classes"] = array(0 => ((($this->getAttribute(        // line 30
(isset($context["project"]) ? $context["project"] : null), "status", array()) == twig_constant("UPDATE_NOT_SECURE"))) ? ("project-update__status--security-error") : ("")), 1 => ((($this->getAttribute(        // line 31
(isset($context["project"]) ? $context["project"] : null), "status", array()) == twig_constant("UPDATE_REVOKED"))) ? ("project-update__status--revoked") : ("")), 2 => ((($this->getAttribute(        // line 32
(isset($context["project"]) ? $context["project"] : null), "status", array()) == twig_constant("UPDATE_NOT_SUPPORTED"))) ? ("project-update__status--not-supported") : ("")), 3 => ((($this->getAttribute(        // line 33
(isset($context["project"]) ? $context["project"] : null), "status", array()) == twig_constant("UPDATE_NOT_CURRENT"))) ? ("project-update__status--not-current") : ("")), 4 => ((($this->getAttribute(        // line 34
(isset($context["project"]) ? $context["project"] : null), "status", array()) == twig_constant("UPDATE_CURRENT"))) ? ("project-update__status--current") : ("")));
        // line 37
        echo "<div";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["status"]) ? $context["status"] : null), "attributes", array()), "addClass", array(0 => "project-update__status", 1 => (isset($context["status_classes"]) ? $context["status_classes"] : null)), "method"), "html", null, true));
        echo ">";
        // line 38
        if ($this->getAttribute((isset($context["status"]) ? $context["status"] : null), "label", array())) {
            // line 39
            echo "<span>";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["status"]) ? $context["status"] : null), "label", array()), "html", null, true));
            echo "</span>";
        } else {
            // line 41
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["status"]) ? $context["status"] : null), "reason", array()), "html", null, true));
        }
        // line 43
        echo "  <span class=\"project-update__status-icon\">
    ";
        // line 44
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["status"]) ? $context["status"] : null), "icon", array()), "html", null, true));
        echo "
  </span>
</div>

<div class=\"project-update__title\">";
        // line 49
        if ((isset($context["url"]) ? $context["url"] : null)) {
            // line 50
            echo "<a href=\"";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["url"]) ? $context["url"] : null), "html", null, true));
            echo "\">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title"]) ? $context["title"] : null), "html", null, true));
            echo "</a>";
        } else {
            // line 52
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title"]) ? $context["title"] : null), "html", null, true));
        }
        // line 54
        echo "  ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["existing_version"]) ? $context["existing_version"] : null), "html", null, true));
        echo "
  ";
        // line 55
        if ((((isset($context["install_type"]) ? $context["install_type"] : null) == "dev") && (isset($context["datestamp"]) ? $context["datestamp"] : null))) {
            // line 56
            echo "    <span class=\"project-update__version-date\">(";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["datestamp"]) ? $context["datestamp"] : null), "html", null, true));
            echo ")</span>
  ";
        }
        // line 58
        echo "</div>

";
        // line 60
        if ((isset($context["versions"]) ? $context["versions"] : null)) {
            // line 61
            echo "  ";
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["versions"]) ? $context["versions"] : null));
            foreach ($context['_seq'] as $context["_key"] => $context["version"]) {
                // line 62
                echo "    ";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $context["version"], "html", null, true));
                echo "
  ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['version'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
        }
        // line 65
        echo "
";
        // line 67
        $context["extra_classes"] = array(0 => ((($this->getAttribute(        // line 68
(isset($context["project"]) ? $context["project"] : null), "status", array()) == twig_constant("UPDATE_NOT_SECURE"))) ? ("project-not-secure") : ("")), 1 => ((($this->getAttribute(        // line 69
(isset($context["project"]) ? $context["project"] : null), "status", array()) == twig_constant("UPDATE_REVOKED"))) ? ("project-revoked") : ("")), 2 => ((($this->getAttribute(        // line 70
(isset($context["project"]) ? $context["project"] : null), "status", array()) == twig_constant("UPDATE_NOT_SUPPORTED"))) ? ("project-not-supported") : ("")));
        // line 73
        echo "<div class=\"project-updates__details\">
  ";
        // line 74
        if ((isset($context["extras"]) ? $context["extras"] : null)) {
            // line 75
            echo "    <div class=\"extra\">
      ";
            // line 76
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["extras"]) ? $context["extras"] : null));
            foreach ($context['_seq'] as $context["_key"] => $context["extra"]) {
                // line 77
                echo "        <div";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["extra"], "attributes", array()), "addClass", array(0 => (isset($context["extra_classes"]) ? $context["extra_classes"] : null)), "method"), "html", null, true));
                echo ">
          ";
                // line 78
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["extra"], "label", array()), "html", null, true));
                echo ": ";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["extra"], "data", array()), "html", null, true));
                echo "
        </div>
      ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['extra'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 81
            echo "    </div>
  ";
        }
        // line 83
        echo "  ";
        $context["includes"] = twig_join_filter((isset($context["includes"]) ? $context["includes"] : null), ", ");
        // line 84
        echo "  ";
        if ((isset($context["disabled"]) ? $context["disabled"] : null)) {
            // line 85
            echo "    ";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Includes:")));
            echo "
    <ul>
      <li>
        ";
            // line 88
            echo t("Enabled: %includes", array("%includes" =>             // line 89
(isset($context["includes"]) ? $context["includes"] : null), ));
            // line 91
            echo "      </li>
      <li>
        ";
            // line 93
            $context["disabled"] = twig_join_filter((isset($context["disabled"]) ? $context["disabled"] : null), ", ");
            // line 94
            echo "        ";
            echo t("Disabled: %disabled", array("%disabled" =>             // line 95
(isset($context["disabled"]) ? $context["disabled"] : null), ));
            // line 97
            echo "      </li>
    </ul>
  ";
        } else {
            // line 100
            echo "    ";
            echo t("Includes: %includes", array("%includes" =>             // line 101
(isset($context["includes"]) ? $context["includes"] : null), ));
            // line 103
            echo "  ";
        }
        // line 104
        echo "</div>
";
        
        $__internal_7dc25ae5a92cce2eb222230a9d779dde202e4b56676c6fe4ada0f2987bf66601->leave($__internal_7dc25ae5a92cce2eb222230a9d779dde202e4b56676c6fe4ada0f2987bf66601_prof);

    }

    public function getTemplateName()
    {
        return "core/themes/stable/templates/admin/update-project-status.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  201 => 104,  198 => 103,  196 => 101,  194 => 100,  189 => 97,  187 => 95,  185 => 94,  183 => 93,  179 => 91,  177 => 89,  176 => 88,  169 => 85,  166 => 84,  163 => 83,  159 => 81,  148 => 78,  143 => 77,  139 => 76,  136 => 75,  134 => 74,  131 => 73,  129 => 70,  128 => 69,  127 => 68,  126 => 67,  123 => 65,  113 => 62,  108 => 61,  106 => 60,  102 => 58,  96 => 56,  94 => 55,  89 => 54,  86 => 52,  79 => 50,  77 => 49,  70 => 44,  67 => 43,  64 => 41,  59 => 39,  57 => 38,  53 => 37,  51 => 34,  50 => 33,  49 => 32,  48 => 31,  47 => 30,  46 => 29,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override for the project status report.*/
/*  **/
/*  * Available variables:*/
/*  * - title: The project title.*/
/*  * - url: The project url.*/
/*  * - status: The project status.*/
/*  *   - label: The project status label.*/
/*  *   - attributes: HTML attributes for the project status.*/
/*  *   - reason: The reason you should update the project.*/
/*  *   - icon: The project status version indicator icon.*/
/*  * - existing_version: The version of the installed project.*/
/*  * - versions: The available versions of the project.*/
/*  * - install_type: The type of project (e.g., dev).*/
/*  * - datestamp: The date/time of a project version's release.*/
/*  * - extras: HTML attributes and additional information about the project.*/
/*  *   - attributes: HTML attributes for the extra item.*/
/*  *   - label: The label for an extra item.*/
/*  *   - data: The data about an extra item.*/
/*  * - includes: The projects within the project.*/
/*  * - disabled: The currently disabled projects in the project.*/
/*  **/
/*  * @see template_preprocess_update_project_status()*/
/*  *//* */
/* #}*/
/* {%*/
/*   set status_classes = [*/
/*     project.status == constant('UPDATE_NOT_SECURE') ? 'project-update__status--security-error',*/
/*     project.status == constant('UPDATE_REVOKED') ? 'project-update__status--revoked',*/
/*     project.status == constant('UPDATE_NOT_SUPPORTED') ? 'project-update__status--not-supported',*/
/*     project.status == constant('UPDATE_NOT_CURRENT') ? 'project-update__status--not-current',*/
/*     project.status == constant('UPDATE_CURRENT') ? 'project-update__status--current',*/
/*   ]*/
/* %}*/
/* <div{{ status.attributes.addClass('project-update__status', status_classes) }}>*/
/*   {%- if status.label -%}*/
/*     <span>{{ status.label }}</span>*/
/*   {%- else -%}*/
/*     {{ status.reason }}*/
/*   {%- endif %}*/
/*   <span class="project-update__status-icon">*/
/*     {{ status.icon }}*/
/*   </span>*/
/* </div>*/
/* */
/* <div class="project-update__title">*/
/*   {%- if url -%}*/
/*     <a href="{{ url }}">{{ title }}</a>*/
/*   {%- else -%}*/
/*     {{ title }}*/
/*   {%- endif %}*/
/*   {{ existing_version }}*/
/*   {% if install_type == 'dev' and datestamp %}*/
/*     <span class="project-update__version-date">({{ datestamp }})</span>*/
/*   {% endif %}*/
/* </div>*/
/* */
/* {% if versions %}*/
/*   {% for version in versions %}*/
/*     {{ version }}*/
/*   {% endfor %}*/
/* {% endif %}*/
/* */
/* {%*/
/*   set extra_classes = [*/
/*     project.status == constant('UPDATE_NOT_SECURE') ? 'project-not-secure',*/
/*     project.status == constant('UPDATE_REVOKED') ? 'project-revoked',*/
/*     project.status == constant('UPDATE_NOT_SUPPORTED') ? 'project-not-supported',*/
/*   ]*/
/* %}*/
/* <div class="project-updates__details">*/
/*   {% if extras %}*/
/*     <div class="extra">*/
/*       {% for extra in extras %}*/
/*         <div{{ extra.attributes.addClass(extra_classes) }}>*/
/*           {{ extra.label }}: {{ extra.data }}*/
/*         </div>*/
/*       {% endfor %}*/
/*     </div>*/
/*   {% endif %}*/
/*   {% set includes = includes|join(', ') %}*/
/*   {% if disabled %}*/
/*     {{ 'Includes:'|t }}*/
/*     <ul>*/
/*       <li>*/
/*         {% trans %}*/
/*           Enabled: {{ includes|placeholder }}*/
/*         {% endtrans %}*/
/*       </li>*/
/*       <li>*/
/*         {% set disabled = disabled|join(', ') %}*/
/*         {% trans %}*/
/*           Disabled: {{ disabled|placeholder }}*/
/*         {% endtrans %}*/
/*       </li>*/
/*     </ul>*/
/*   {% else %}*/
/*     {% trans %}*/
/*       Includes: {{ includes|placeholder }}*/
/*     {% endtrans %}*/
/*   {% endif %}*/
/* </div>*/
/* */
