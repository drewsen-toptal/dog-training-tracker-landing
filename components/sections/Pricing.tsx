"use client";

import { Check, Shield } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { TrustBadges } from "@/components/TrustBadges";

const pricingTiers = [
  {
    name: "Puppy",
    description: "First-time dog owners focused on one furry friend",
    price: 19,
    originalPrice: 49,
    features: [
      "1 dog profile",
      "All training features",
      "Built-in clicker",
      "Offline mode",
      "Progress tracking",
      "50+ command guides",
      "Lifetime updates",
      "Email support",
    ],
    cta: "Get Started - $19",
    popular: false,
  },
  {
    name: "Pack Leader",
    description: "Multi-dog households and serious trainers",
    price: 39,
    originalPrice: 99,
    features: [
      "Unlimited dog profiles",
      "All training features",
      "Built-in clicker",
      "Offline mode",
      "Progress tracking",
      "50+ command guides",
      "Lifetime updates",
      "Priority email support",
      "Early access to new features",
    ],
    cta: "Get Pack Leader - $39",
    popular: true,
  },
  {
    name: "Family",
    description: "Households where everyone trains the dog(s)",
    price: 59,
    originalPrice: 149,
    features: [
      "Unlimited dog profiles",
      "3 device licenses",
      "Family sharing via iCloud",
      "All training features",
      "Built-in clicker",
      "Offline mode",
      "Progress tracking",
      "50+ command guides",
      "Lifetime updates",
      "Priority email support",
      "Early access to new features",
    ],
    cta: "Get Family Plan - $59",
    popular: false,
  },
];

const comparisonData = [
  { label: "Year 1 Cost", us: "$39", them: "$564 ($47/month)" },
  { label: "Year 2 Cost", us: "$0", them: "$564" },
  { label: "5-Year Cost", us: "$39", them: "$2,820" },
  { label: "Hidden Fees", us: "None", them: "Auto-renewal traps" },
  { label: "Dogs Included", us: "Unlimited", them: "Usually 1" },
];

export function Pricing() {
  return (
    <section id="pricing" className="py-16 md:py-20 lg:py-24">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        {/* Section Header */}
        <div className="mx-auto mb-12 max-w-2xl text-center md:mb-16">
          <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
            Simple Pricing. No Surprises. Ever.
          </h2>
          <p className="mt-4 text-muted-foreground">
            Choose your plan. Pay once. Train forever.
          </p>
        </div>

        {/* Pricing Cards */}
        <div className="mx-auto grid max-w-6xl gap-6 md:grid-cols-2 lg:grid-cols-3 lg:gap-8">
          {pricingTiers.map((tier, index) => (
            <Card
              key={index}
              className={`relative flex flex-col ${
                tier.popular
                  ? "border-2 border-primary shadow-lg"
                  : "border-border/50"
              }`}
            >
              {/* Popular Badge */}
              {tier.popular && (
                <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                  <Badge className="bg-primary text-primary-foreground">
                    BEST VALUE
                  </Badge>
                </div>
              )}

              <CardHeader className="pb-4">
                <CardTitle className="text-lg">{tier.name}</CardTitle>
                <CardDescription>{tier.description}</CardDescription>
              </CardHeader>

              <CardContent className="flex flex-1 flex-col">
                {/* Price */}
                <div className="mb-6">
                  <div className="flex items-baseline gap-2">
                    <span className="text-lg text-muted-foreground line-through">
                      ${tier.originalPrice}
                    </span>
                    <span className="text-4xl font-bold tracking-tight text-foreground">
                      ${tier.price}
                    </span>
                  </div>
                  <p className="mt-1 text-sm text-muted-foreground">
                    One-time payment
                  </p>
                </div>

                {/* Feature List */}
                <ul className="mb-8 flex-1 space-y-3">
                  {tier.features.map((feature, featureIndex) => (
                    <li key={featureIndex} className="flex items-start gap-3">
                      <Check className="mt-0.5 h-5 w-5 shrink-0 text-primary" aria-hidden="true" />
                      <span className={`text-sm ${featureIndex < 3 && tier.popular ? "font-medium text-foreground" : "text-muted-foreground"}`}>
                        {feature}
                      </span>
                    </li>
                  ))}
                </ul>

                {/* CTA Button */}
                <Button
                  className="w-full"
                  variant={tier.popular ? "default" : "outline"}
                  onClick={() => {
                    // Scroll to waitlist form to capture leads
                    const heroSection = document.querySelector('[aria-label="Email address for waitlist"]');
                    if (heroSection) {
                      heroSection.scrollIntoView({ behavior: "smooth", block: "center" });
                      (heroSection as HTMLInputElement).focus();
                    }
                  }}
                  aria-label={`${tier.cta} - Join waitlist for ${tier.name} plan`}
                >
                  {tier.cta}
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Trust Badges */}
        <div className="mx-auto mt-12 max-w-4xl">
          <TrustBadges />
        </div>

        {/* Comparison Table */}
        <div className="mx-auto mt-16 max-w-2xl">
          <h3 className="mb-6 text-center text-xl font-semibold">
            vs. Subscription Apps
          </h3>
          <div className="overflow-hidden rounded-xl border border-border">
            <div className="grid grid-cols-3 bg-muted font-semibold">
              <div className="border-b border-r border-border p-4 text-sm"></div>
              <div className="border-b border-r border-border p-4 text-center text-sm text-primary">
                Dog Training Tracker
              </div>
              <div className="border-b border-border p-4 text-center text-sm text-muted-foreground">
                Typical Subscription App
              </div>
            </div>
            {comparisonData.map((row, index) => (
              <div key={index} className="grid grid-cols-3">
                <div className="border-b border-r border-border bg-muted/50 p-4 text-sm font-medium">
                  {row.label}
                </div>
                <div className="border-b border-r border-border p-4 text-center text-sm font-semibold text-primary">
                  {row.us}
                </div>
                <div className="border-b border-border p-4 text-center text-sm text-muted-foreground">
                  {row.them}
                </div>
              </div>
            ))}
          </div>
          <p className="mt-4 text-center text-lg font-semibold text-primary">
            Save $2,781 over 5 years. That&apos;s a lot of treats.
          </p>
        </div>

        {/* Money-Back Guarantee */}
        <div className="mx-auto mt-12 max-w-xl text-center">
          <div className="inline-flex items-center gap-2 rounded-full bg-primary/10 px-4 py-2 text-primary">
            <Shield className="h-5 w-5" aria-hidden="true" />
            <span className="font-semibold">30-Day &ldquo;Happy Pup&rdquo; Guarantee</span>
          </div>
          <p className="mt-4 text-sm text-muted-foreground">
            Not seeing results? Not loving the app? Email us within 30 days and we&apos;ll
            refund every penny. No questions asked, no hoops to jump through.
          </p>
        </div>

        {/* Founding Member Note - Updated */}
        <div className="mx-auto mt-8 max-w-lg rounded-xl border border-secondary/50 bg-secondary/10 p-6 text-center">
          <p className="font-semibold text-foreground">Founding Member Pricing</p>
          <p className="mt-2 text-sm text-muted-foreground">
            These are our launch prices for early supporters.
            Regular pricing: Puppy $49, Pack Leader $99, Family $149
          </p>
          <p className="mt-3 text-lg font-bold text-secondary">
            Save up to 60% today
          </p>
        </div>
      </div>
    </section>
  );
}
