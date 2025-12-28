import { LucideIcon } from "lucide-react";

// Pricing types
export interface PricingTier {
  name: string;
  description: string;
  price: number;
  originalPrice: number;
  features: string[];
  cta: string;
  popular: boolean;
}

export interface ComparisonRow {
  label: string;
  us: string;
  them: string;
}

// Feature types
export interface MainFeature {
  icon: LucideIcon;
  title: string;
  subtitle: string;
  description: string;
  highlight: string;
  tagline: string;
}

export interface BonusFeature {
  icon: LucideIcon;
  label: string;
}

// Testimonial types
export interface Testimonial {
  quote: string;
  headline: string;
  author: string;
  context: string;
  result: string;
  photo: string;
  dogBreed: string;
}

// FAQ types
export interface FAQItem {
  question: string;
  answer: string;
}

// App Screenshot types
export interface Screenshot {
  title: string;
  description: string;
  image: string;
}
