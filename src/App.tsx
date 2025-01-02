import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import Website from '@/pages/Website';
import DashboardLayout from '@/components/layout/DashboardLayout';
import LoadingSpinner from '@/components/ui/LoadingSpinner';

// Admin Pages
import Dashboard from '@/pages/admin/Dashboard';
import Posts from '@/pages/admin/Posts';
import Services from '@/pages/admin/Services';
import FAQs from '@/pages/admin/FAQs';
import Testimonials from '@/pages/admin/Testimonials';
import Media from '@/pages/admin/Media';
import AIChatManagement from '@/pages/admin/AIChatManagement';
import Analytics from '@/pages/admin/Analytics';
import Users from '@/pages/admin/Users';
import About from '@/pages/admin/About';

// Protected Route Component
const ProtectedRoute: React.FC<{
  children: React.ReactNode;
  requiredRole?: string;
}> = ({ children, requiredRole }) => {
  const { user, isLoading } = useAuth();

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-900">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/" replace />;
  }

  if (requiredRole && user.user_metadata?.role !== requiredRole) {
    return <Navigate to="/" replace />;
  }

  return <>{children}</>;
};

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <Routes>
        {/* Public Routes */}
        <Route path="/" element={<Website />} />

        {/* Protected Admin Routes */}
        <Route
          path="/admin"
          element={
            <ProtectedRoute requiredRole="admin">
              <DashboardLayout />
            </ProtectedRoute>
          }
        >
          <Route index element={<Dashboard />} />
          <Route path="posts" element={<Posts />} />
          <Route path="services" element={<Services />} />
          <Route path="faqs" element={<FAQs />} />
          <Route path="testimonials" element={<Testimonials />} />
          <Route path="media" element={<Media />} />
          <Route path="ai-chat" element={<AIChatManagement />} />
          <Route path="analytics" element={<Analytics />} />
          <Route path="users" element={<Users />} />
          <Route path="about" element={<About />} />
        </Route>

        {/* Catch all */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
