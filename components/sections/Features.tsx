import { DollarSign, Zap, Users, Wifi, MousePointer2, TrendingUp, Timer, Bell, BookOpen, Camera, Moon, Cloud } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";

const mainFeatures = [
  {
    icon: DollarSign,
    title: "Never Get Charged Again",
    subtitle: "One-Time Purchase",
    description: "Pay $39 today. Use the app for the next 10 years. While other dog owners watch $47/month drain from their accounts, you're spending that money on treats and toys instead.",
    highlight: "Over 2 years, that's $1,128 saved compared to typical subscription apps.",
    tagline: "Your wallet will thank you. Your dog won't care, but will appreciate the extra treats.",
  },
  {
    icon: Zap,
    title: "Start Training in 30 Seconds",
    subtitle: "No Account Required",
    description: "Download. Open. Add your dog's name. Done. No email verification. No password to create (and forget). No 2FA codes to hunt down.",
    highlight: "You came here to train your dog, not fill out forms.",
    tagline: "First-time setup takes less time than teaching \"sit.\"",
  },
  {
    icon: Users,
    title: "Your Whole Pack, One App",
    subtitle: "Unlimited Dogs",
    description: "Luna, Max, Bella, Cooper, and that foster you're \"definitely not keeping\" (you're keeping him). Add them all. Track them separately. No per-dog fees.",
    highlight: "Whether you have 1 dog or 12, the price is the same.",
    tagline: "Because charging per dog is a pet peeve. Pun intended.",
  },
  {
    icon: Wifi,
    title: "Train Anywhere Signal Can't Reach",
    subtitle: "Full Offline Mode",
    description: "The best training happens outside. Parks. Trails. Beaches. Places with terrible cell service. Every feature works offline.",
    highlight: "Everything syncs automatically when you're back online.",
    tagline: "No WiFi? No problem. No excuses either.",
  },
  {
    icon: MousePointer2,
    title: "Perfect Timing, Every Time",
    subtitle: "Built-In Clicker",
    description: "That half-second between behavior and reward? It matters. Our built-in clicker responds instantly. Adjustable sound. Haptic feedback option.",
    highlight: "One tap to mark, no fumbling for a separate tool you left in your other jacket.",
    tagline: "Mark the moment. Reward the behavior. Build the habit.",
  },
  {
    icon: TrendingUp,
    title: "See How Far You've Come",
    subtitle: "Visual Progress Tracking",
    description: "Remember when Luna couldn't walk past another dog without losing her mind? The app does. See your training history. Track command mastery. Watch the progress charts climb.",
    highlight: "On hard days, look back and remember: you've already come so far.",
    tagline: "Every small win, documented. Every breakthrough, celebrated.",
  },
];

const bonusFeatures = [
  { icon: Timer, label: "Session Timer" },
  { icon: Bell, label: "Training Reminders" },
  { icon: BookOpen, label: "50+ Command Guides" },
  { icon: Camera, label: "Notes & Photos" },
  { icon: Moon, label: "Dark Mode" },
  { icon: Cloud, label: "iCloud Sync" },
];

export function Features() {
  return (
    <section id="features" className="py-16 md:py-20 lg:py-24 bg-muted/30">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        {/* Section Header */}
        <div className="mx-auto mb-12 max-w-2xl text-center md:mb-16">
          <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
            Everything You Need. Nothing You Don&apos;t.
          </h2>
          <p className="mt-4 text-muted-foreground">
            Professional-grade tools designed for everyday dog owners.
          </p>
        </div>

        {/* Main Features Grid */}
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 lg:gap-8">
          {mainFeatures.map((feature, index) => (
            <Card key={index} className="group relative overflow-hidden border-border/50 transition-all duration-300 hover:border-primary/50 hover:shadow-lg">
              <CardContent className="p-6 md:p-8">
                {/* Icon */}
                <div className="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-primary/10 text-primary transition-transform duration-300 group-hover:scale-110">
                  <feature.icon className="h-6 w-6" />
                </div>

                {/* Subtitle */}
                <p className="text-xs font-semibold uppercase tracking-wider text-primary">
                  {feature.subtitle}
                </p>

                {/* Title */}
                <h3 className="mt-2 text-lg font-semibold text-foreground md:text-xl">
                  {feature.title}
                </h3>

                {/* Description */}
                <p className="mt-3 text-sm text-muted-foreground leading-relaxed">
                  {feature.description}
                </p>

                {/* Highlight */}
                <p className="mt-3 text-sm font-medium text-foreground">
                  {feature.highlight}
                </p>

                {/* Tagline */}
                <p className="mt-3 text-xs italic text-muted-foreground">
                  {feature.tagline}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Bonus Features */}
        <div className="mt-16">
          <h3 className="mb-8 text-center text-xl font-semibold">
            Bonus Features
          </h3>
          <div className="flex flex-wrap items-center justify-center gap-4">
            {bonusFeatures.map((feature, index) => (
              <div
                key={index}
                className="flex items-center gap-2 rounded-full border border-border bg-card px-4 py-2 text-sm"
              >
                <feature.icon className="h-4 w-4 text-primary" />
                <span>{feature.label}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
